# Jinda Gem - Quick Start Guide: Building a Notes, Articles, or Documents App

Jinda generates complete Rails applications from a Freemind mindmap file (`app/jinda/index.mm`). All generated code (models, controllers, views, etc.) originates from templates in the Jinda gem at `$HOME/mygem/jinda/lib/generators/jinda/templates/app`. During `rails generate jinda:install` and `rake jinda:update`, these templates are copied and populated based on your mindmap. Code between `# jinda begin` and `# jinda end` in generated files is overwritten on updates; add custom code outside these markers to preserve it.

This guide focuses on using the default mindmap to manage Notes, Articles, or Documents. The default `index.mm` (generated from the gem template) includes ready-to-use branches for these. Edit `app/jinda/index.mm` in Freemind, save, then run `rake jinda:update` to regenerate code.

![Default Mindmap](doc/images/map_index.png)

The mindmap has three main branches:
- **models**: Defines MongoDB models (via Mongoid).
- **services**: Defines left-side menu modules (main menu) and services (sub-menu workflows).
- **roles**: Defines user roles (e.g., admin, member). Defaults suffice; leave intact unless customizing.

## Models: Defining Your Data Structure

The default **models** branch includes samples like `person`, `address`, `article`, `note`, `picture`, and `comment`. For a Notes app, use/modify `note`; for Articles, use `article`; for Documents, adapt `picture` or add `document`.

Under a model (singular, Rails convention), sub-branches define fields:
- Plain text (e.g., `title`): Default String field.
- With type (e.g., `body: text`): Mongoid type (string, integer, date, boolean, array, etc.).
- Raw code (e.g., `belongs_to :user`): Right-click branch > Insert > Icon > pen (edit icon) to add Mongoid associations, validations, indexes, etc.
- File uploads (e.g., `file`): Use String; Jinda handles storage (filesystem/Cloudinary) and URL generation.

Example: Default `note` model (for Notes app):

```
models
└── note
    ├── include Mongoid::Attributes::Dynamic (pen icon: enables dynamic fields)
    ├── title (String)
    ├── body (text)
    ├── belongs_to :user (pen icon: association)
    ├── before_validation :ensure_title_has_a_value (pen icon: callback)
    ├── validates :title, length: { maximum: 30 }, presence: true (pen icon: validation)
    └── private def ensure_title_has_a_value ... end (pen icon: method)
```

![models-note](doc/images/models_note.png)

Save and run `rake jinda:update`. This updates `app/models/note.rb` (generated from gem template `lib/generators/jinda/templates/app/models/note.rb`):

```ruby
# jinda begin
class Note
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  field :title, type: String
  field :body, type: String
  belongs_to :user
  before_validation :ensure_title_has_a_value
  validates :title, presence: true, length: { maximum: 30 }
  # ... private method ...
  # jinda end
end
```

For Articles (`article` model): Fields like `title`, `text`, `body`, with `belongs_to :user` and `has_many :comments`.

For Documents: Modify `picture` (fields: `picture`, `description`, `belongs_to :user`) or add `document` with `title`, `file: string`, `belongs_to :user`.

Add custom code (e.g., scopes) outside markers.

## Services: Building Menus and Workflows

Defaults include `users`, `admins`, `devs` (leave intact for auth/admin). Ready services: `notes: Notes` (for Notes), `articles: Article` (for Articles), `docs: Document` (for Documents).

Each module (first sub-branch, e.g., `notes: Notes`) creates:
- Controller (`app/controllers/notes_controller.rb`, from template).
- Main menu item ("Notes").

Sub-branches define access/steps:
- `role: m`: Restricts to 'm' (member role).
- `link:label:/path`: Simple link (e.g., `link:My Notes:/notes/my` → submenu linking to user notes).
- Service branches: Multi-step workflows.
  - Screen icon (UI): View form (e.g., `new_note: New` → `app/views/notes/new/new_note.html.erb`, from template).
    - Sub-branch rules: e.g., `role: m` or `rule: login? && own_note?`.
  - Bookmark icon: Controller method (e.g., `create` → `def create`).
  - Forward icon: Redirect (e.g., to `/notes/my`).

Example: Default `notes: Notes` service (for creating/editing notes):

```
services
└── notes: Notes (module: menu "Notes")
    ├── link:My Notes:/notes/my (role: m)
    └── new: New Note (service)
        ├── new_note: New (screen icon, role: m)
        ├── create: Create (bookmark icon)
        └── /notes/my (forward icon: redirect)
    ├── edit: Edit (service)
        ├── select_note: Select (screen, role: m)
        ├── edit_note: Edit (screen, role: m)
        └── update: Update (bookmark)
    ├── delete: Delete (service, fork style)
        ├── select_note: Select (screen, role: m)
        └── delete: Delete (bookmark)
    └── ... (mail, xedit)
```

![services-notes](doc/images/services_notes.png)

Example: Add an "articles" module (default `articles: Article` service, for creating/editing articles with comments):

```
services
└── articles: Article (module: menu "Articles")
    ├── link:All Articles:/articles
    ├── link:My article:/articles/my (role: m)
    └── new_article: New Article (service)
        ├── form_article: New Article (screen icon, role: m)
        ├── create: Create Article (bookmark icon)
        └── /articles/my (forward icon: redirect)
    ├── edit_article: Edit Article (service)
        ├── select_article: Select Article (screen, role: m)
        ├── edit_article: Edit Article (screen, role: m)
        └── j_update: Update Article (bookmark)
    ├── xedit_article: xEdit Article (hidden service)
        ├── edit_article: Edit Article (screen, role: m)
        └── j_update: Update Article (bookmark)
    └── comments: Comment (service, linked to articles)
        ├── new_comment: New Comment (role: m)
        │   └── create (bookmark)
        └── /articles/my (forward icon: redirect)
```

![services-articles](doc/images/services_articles.png)

Save and run `rake jinda:update`. Generates/updates:
- `app/controllers/notes_controller.rb` (skeleton from template; add custom logic outside markers).
- Views like `app/views/notes/new/new_note.html.erb` (basic form from template; uncomment/edit fields):

```erb
<!-- app/views/notes/new/new_note.html.erb -->
<h1>New Note</h1>

<%= f.text_field :title, placeholder: "Note Title" %>
<%= f.text_area :body, placeholder: "Note Body", rows: 10 %>

<!-- Jinda provides form_tag, submit -->
```

In controller, implement methods (e.g., `create` outside markers):

```ruby
# app/controllers/notes_controller.rb

class NotesController < ApplicationController
  # jinda begin
  # ... generated skeleton ...
  # jinda end

  def create
    @note = Note.new(note_params)
    @note.user = current_user
    if @note.save
      redirect_to notes_my_path, notice: "Note created!"
    else
      render :new_note
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :body)
  end
end
```

Similar for `articles: Article` (create/edit with comments) and `docs: Document` (new/edit with file upload).

For full CRUD: Defaults include list (`/notes/my`), edit, delete. Add steps like `show_note: Show` (screen icon) for views.

Test: `rails s`, login (admin/secret), navigate to "Notes" > "new".

## Roles: User Permissions

Defaults: `m: member` (basic), `a: admin` (full), `d: developer`. Reference in services (e.g., `role: m`). Add roles like `editor: Editor` if needed.

## Next Steps

- Seed: `rails jinda:seed`.
- MongoDB: `docker run -d -p 27017:27017 mongo`.
- Customize: Edit mindmap (e.g., add fields to `note`), run `rake jinda:update`.
- Themes: `gem 'jinda_adminlte'; bundle install; rails g jinda_adminlte:install`.
- API: Defaults include `api/v1/notes` for RESTful endpoints.
- Advanced: Multi-step rules, polymorphic comments (already in `comment` model).

Iterate: Modify mindmap, update, test login/menu at `localhost:3000`. For new apps, extend defaults for your Notes/Articles/Documents workflow.