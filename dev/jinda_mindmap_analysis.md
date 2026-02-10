# Jinda Mindmap System - Comprehensive Analysis and jinda_mindmap Plan

## Executive Summary

**Goal**: Create `jinda_mindmap` - an in-browser JavaScript mindmap editor using jsMind to replace external FreeMind editing of `index.mm`, enabling admins to visually edit the entire application structure (models, services, roles) with validation and real-time code generation.

**Development Location**: `~/mygem/jinda/test/dummy` (working Jinda app for testing)

---

## 1. Understanding Jinda's Current Mindmap System

### 1.1 Core Concept
- **Single Source of Truth**: `app/jinda/index.mm` (FreeMind XML) defines entire Rails application
- **Generator Flow**: Edit mindmap → Run `rake jinda:update` → Generates/updates Rails code
- **Three Main Branches**: models, services, roles

### 1.2 Mindmap Structure from jinda.png

#### **Models Branch**
- **Purpose**: Define MongoDB collections and fields
- **Structure**:
  ```
  models
  ├── person (model name, singular)
  │   ├── fname (field: string - default type)
  │   ├── sex: integer (field with explicit type)
  │   ├── dob: date
  │   ├── user: belongs_to (association with pen/edit icon)
  │   └── validate: title, :text, presence: true
  ├── address
  │   ├── street
  │   └── lat: float
  └── article
      ├── title
      └── body: text
  ```
- **Field Format**: `field_name: field_type` or special directives
- **Special Nodes** (with edit icon Alt-I):
  - `belongs_to :model_name` - associations
  - `validate: ...` - validation rules
  - `include Mongoid::Attributes::Dynamic` - special behaviors

#### **Services Branch**
- **Purpose**: Define controllers, views, workflows, and menus
- **Structure**:
  ```
  services
  ├── articles:Articles (module_code:Menu Label)
  │   ├── role: admin (module-level role restriction)
  │   ├── create:Create Article (service_code:Sub Menu Name)
  │   │   ├── form_article: Article Form (attach icon = form step)
  │   │   │   └── role: member (step-level role)
  │   │   └── create: Save (bookmark icon = controller action)
  │   ├── edit:Edit Article (2-step edit workflow)
  │   │   ├── select_article: Select (form for selection)
  │   │   └── edit_article: Edit Form (form for editing)
  │   │       └── update: Update (action to save)
  │   └── link:View All:/articles (simple link, no workflow)
  ├── admins:Admin Panel
  │   └── edit_role:Edit Roles (admin-only service)
  │       └── role: admin
  └── docs:Documentation
      └── new:New Doc
          ├── doc_form: Enter Doc (form)
          └── create: Save Doc (action)
  ```

- **Icon-to-Action Mapping** (from `gen_freemind.rb`):
  - `attach` → `form` (view/form step)
  - `bookmark` → `do` (controller action/method)
  - `forward` → `direct_to` (redirect)
  - `kaddressbook` → `invoke` (invoke another service)
  - `idea` → `output` (display output)
  - `list` → `list` (list view)
  - `mail` → `mail` (email action)
  - `button_cancel` → unlisted (hidden from menu)
  - `password` → secured (requires security)

- **Options** (child nodes):
  - `role: admin, member, etc.` - role restriction (comma-separated)
  - `rule: login? && own_xmain?` - Ruby rule evaluated at runtime
  - `confirm: Are you sure?` - confirmation dialog
  - `display: true/false` - show output or not

#### **Roles Branch**
- **Purpose**: Define user roles
- **Structure**:
  ```
  roles
  ├── admin
  ├── member
  └── developer
  ```

### 1.3 Code Generation Flow

#### **Phase 1: Parse XML** (`get_app` in `init_vars.rb`)
```ruby
@app = REXML::Document.new(File.read("app/jinda/index.mm"))
```

#### **Phase 2: Process Models** (`gen_models.rb`)
1. Find `models` branch: `@app.elements["//node[@TEXT='models']"]`
2. For each child node (model):
   - Extract model name: `model.attributes['TEXT']` → convert to code
   - Generate model file: `rails generate model #{model_code}` if not exists
   - Parse fields with `make_fields(model)`:
     - Iterate child nodes
     - Parse format: `field_name: field_type`
     - Handle special cases: edit icon nodes, associations, validations
   - Generate field definitions between `# jinda begin` and `# jinda end` markers:
     ```ruby
     field :fname, :type => String
     field :sex, :type => Integer
     ```
   - Preserve code outside markers

#### **Phase 3: Process Services** (`gen_services.rb`)
1. Find `services` branch
2. For each child node (module):
   - Extract: `code:name` → create `Jinda::Module` record in MongoDB
   - Extract icon: `m_icon(m)` for menu display
   - Module options: check for `role` child node
3. For each grandchild node (service):
   - Check if `link:` format → create link service
   - Otherwise, create workflow service
   - Extract first step to get service-level `role` and `rule`
   - Save as `Jinda::Service` record with XML, module_id, roles
4. Services stored in DB drive menu rendering

#### **Phase 4: Process Controllers** (`gen_controller.rb`)
- Generate controller file: `app/controllers/#{module_code}_controller.rb`
- Inject code between jinda markers for each service method

#### **Phase 5: Process Views** (`rake_views.rb`)
- For each service with form steps (attach icon):
  - Create directory: `app/views/#{module}/#{service}/`
  - Copy template: `lib/generators/jinda/templates/app/jinda/template/`
  - Generate file: `#{step_code}.html.erb`

#### **Phase 6: Create Runseqs** (`gen_runseq.rb`)
- When service is invoked (user clicks menu):
  - Create `Jinda::Xmain` (transaction instance)
  - For each step in service XML:
    - Create `Jinda::Runseq` record (step instance)
    - Extract action from icon: `freemind2action(icon)`
    - Store role, rule, step number, form_step number
- Workflow execution:
  - Check `authorize?` before each step (eval rule, check role)
  - Execute action (render form or call method)
  - Move to next runseq

### 1.4 Permission System

#### **Role Checking** (from `themes.rb`):
```ruby
# Module level (authorize_init?)
mrole = @service.module.role
return false if mrole && !current_ma_user.has_role(mrole)

# Step level (authorize?)
@runseq.role.upcase.split(',').include?(@user.role.upcase)
```

#### **Rule Evaluation**:
```ruby
eval(@runseq.rule)  # e.g., "login? && own_xmain?"
```

#### **Menu Rendering** (`_menu_mm.haml`):
- Queries `Jinda::Module` and `Jinda::Service` from DB
- Checks user roles before displaying menu items

---

## 2. jinda_mindmap Requirements Analysis

### 2.1 What jinda_mindmap Must Do

#### **A. Visual Editing**
1. Display current `index.mm` as interactive mindmap (like jinda.png)
2. Add/edit/delete nodes (models, services, steps, roles)
3. Drag-and-drop to reorganize
4. Set node properties:
   - Text (name:label format)
   - Icons (attach, bookmark, etc.)
   - Options (role, rule, confirm)

#### **B. Validation**
1. **Client-side** (JavaScript):
   - Required branches exist (models, services, roles)
   - Service format: `code:name`
   - Field format: `name: type`
   - Required icons for service steps
2. **Server-side** (Rails):
   - Validate Ruby syntax in rules: `eval(rule)` with rescue
   - Check valid Mongoid types
   - Check model references in associations

#### **C. Smart Input**
1. **Dropdowns for Field Types**:
   - String, Integer, Float, Boolean, Date, DateTime, Array, Hash
   - Associations: `belongs_to :model`, `has_many :models`
   - Special: `validate: ...`, `include Mongoid::Attributes::Dynamic`
2. **Icon Selector**: Visual picker for FreeMind icons
3. **Role Selector**: Multi-select from existing roles
4. **Rule Builder**: Helper for common rules (`login?`, `own_xmain?`)

#### **D. Sync and Generation**
1. Save button → Convert jsMind JSON to FreeMind XML
2. Update `app/jinda/index.mm`
3. Auto-run `rake jinda:update` (or button to trigger)
4. Show generation results (files created/updated)
5. Reload menu dynamically without server restart

---

## 3. Implementation Plan

### 3.1 Technology Stack
- **Library**: jsMind (open-source, supports JSON, custom data, editing)
- **Rails Integration**: Asset pipeline or Webpacker
- **XML Parsing**: Nokogiri (Ruby)
- **Security**: Admin role only

### 3.2 Architecture

#### **Components**:
1. **MindmapEditorController** (`app/controllers/mindmap_editor_controller.rb`)
   - `edit`: Load index.mm, convert to JSON, render view
   - `save`: Receive JSON, convert to XML, save file, run update
   - Restrict to `before_action :require_admin`

2. **XML ↔ JSON Converter** (`lib/jinda/mindmap_converter.rb`)
   - `xml_to_jsmind(xml_string)`: Parse FreeMind XML → jsMind JSON
   - `jsmind_to_xml(json_hash)`: Convert jsMind JSON → FreeMind XML

3. **View** (`app/views/mindmap_editor/edit.html.erb`)
   - Embed jsMind container
   - Initialize with: `jm.show(mindmap_data)`
   - Controls: Save, Add Node, Edit Node, Delete Node, Icon Picker

4. **JavaScript** (`app/assets/javascripts/mindmap_editor.js`)
   - Initialize jsMind
   - Handle node add/edit/delete events
   - AJAX save to Rails controller
   - Validation before save

### 3.3 Data Format

#### **jsMind JSON Format**:
```json
{
  "meta": {
    "name": "Jinda Mindmap",
    "version": "1.0"
  },
  "format": "node_tree",
  "data": {
    "id": "root",
    "topic": "Jinda",
    "children": [
      {
        "id": "models",
        "topic": "models",
        "children": [
          {
            "id": "person",
            "topic": "person",
            "data": {"type": "model"},
            "children": [
              {
                "id": "fname",
                "topic": "fname",
                "data": {"type": "field", "field_type": "string"}
              },
              {
                "id": "sex",
                "topic": "sex: integer",
                "data": {"type": "field", "field_type": "integer"}
              }
            ]
          }
        ]
      },
      {
        "id": "services",
        "topic": "services",
        "children": [
          {
            "id": "articles",
            "topic": "articles:Articles",
            "data": {"type": "module", "icon": "folder"},
            "children": [
              {
                "id": "create",
                "topic": "create:Create Article",
                "data": {"type": "service"},
                "children": [
                  {
                    "id": "form_article",
                    "topic": "form_article: Article Form",
                    "data": {"type": "step", "icon": "attach", "role": "member"}
                  },
                  {
                    "id": "create_action",
                    "topic": "create: Save",
                    "data": {"type": "step", "icon": "bookmark"}
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "id": "roles",
        "topic": "roles",
        "children": [
          {"id": "admin", "topic": "admin"},
          {"id": "member", "topic": "member"}
        ]
      }
    ]
  }
}
```

#### **FreeMind XML Structure**:
```xml
<map version="1.0.1">
  <node TEXT="Jinda" ID="root">
    <node TEXT="models" POSITION="left">
      <node TEXT="person">
        <node TEXT="fname"/>
        <node TEXT="sex: integer"/>
      </node>
    </node>
    <node TEXT="services" POSITION="right">
      <node TEXT="articles:Articles">
        <icon BUILTIN="folder"/>
        <node TEXT="create:Create Article">
          <node TEXT="form_article: Article Form">
            <icon BUILTIN="attach"/>
            <node TEXT="role: member"/>
          </node>
          <node TEXT="create: Save">
            <icon BUILTIN="bookmark"/>
          </node>
        </node>
      </node>
    </node>
    <node TEXT="roles">
      <node TEXT="admin"/>
      <node TEXT="member"/>
    </node>
  </node>
</map>
```

### 3.4 Converter Logic

#### **XML to JSON** (`xml_to_jsmind`):
```ruby
def xml_to_jsmind(xml_string)
  doc = Nokogiri::XML(xml_string)
  root = doc.at_xpath('//node[@TEXT="Jinda"]') || doc.at_xpath('//node')
  
  {
    meta: { name: "Jinda Mindmap", version: "1.0" },
    format: "node_tree",
    data: parse_node(root)
  }
end

def parse_node(xml_node)
  text = xml_node['TEXT']
  node_id = xml_node['ID'] || SecureRandom.hex(8)
  
  # Extract icon
  icon_elem = xml_node.at_xpath('icon')
  icon = icon_elem ? icon_elem['BUILTIN'] : nil
  
  # Extract data attributes
  data = {}
  data[:icon] = icon if icon
  
  # Determine type based on branch and structure
  if text == 'models'
    data[:type] = 'models_branch'
  elsif text == 'services'
    data[:type] = 'services_branch'
  elsif text == 'roles'
    data[:type] = 'roles_branch'
  elsif parent_text(xml_node) == 'models'
    data[:type] = 'model'
  elsif text.include?(':') && parent_text(xml_node) == 'services'
    data[:type] = 'module'
  end
  
  # Extract options (role, rule, etc.)
  xml_node.xpath('node').each do |child|
    child_text = child['TEXT']
    if child_text =~ /^(role|rule|confirm|display):\s*(.+)/
      data[$1.to_sym] = $2.strip
    end
  end
  
  # Build children (excluding option nodes)
  children = []
  xml_node.xpath('node').each do |child|
    child_text = child['TEXT']
    next if child_text =~ /^(role|rule|confirm|display):/
    children << parse_node(child)
  end
  
  result = {
    id: node_id,
    topic: text
  }
  result[:data] = data unless data.empty?
  result[:children] = children unless children.empty?
  
  result
end
```

#### **JSON to XML** (`jsmind_to_xml`):
```ruby
def jsmind_to_xml(json_hash)
  builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
    xml.map(version: '1.0.1') {
      build_node(xml, json_hash['data'])
    }
  end
  builder.to_xml
end

def build_node(xml, node_data)
  attrs = {
    TEXT: node_data['topic'],
    ID: node_data['id']
  }
  
  xml.node(attrs) {
    # Add icon if present
    if node_data['data'] && node_data['data']['icon']
      xml.icon(BUILTIN: node_data['data']['icon'])
    end
    
    # Add option nodes (role, rule, etc.)
    if node_data['data']
      %w[role rule confirm display].each do |opt|
        if node_data['data'][opt]
          xml.node(TEXT: "#{opt}: #{node_data['data'][opt]}")
        end
      end
    end
    
    # Add children
    if node_data['children']
      node_data['children'].each do |child|
        build_node(xml, child)
      end
    end
  }
end
```

### 3.5 Development Phases

#### **Phase 1: Setup** (Week 1)
1. Add jsMind to `test/dummy`: `yarn add jsmind`
2. Include in asset pipeline: `application.js`, `application.css`
3. Create `MindmapEditorController` with stub methods
4. Create basic view with jsMind container

#### **Phase 2: Converter** (Week 1-2)
1. Implement `xml_to_jsmind` method
2. Test with current `test/dummy/app/jinda/index.mm`
3. Verify JSON structure matches jsMind format
4. Implement `jsmind_to_xml` method
5. Test round-trip: XML → JSON → XML (should be identical)

#### **Phase 3: UI** (Week 2-3)
1. Display mindmap in browser (read-only first)
2. Add node editing:
   - Double-click to edit topic
   - Right-click menu: Add Child, Delete, Edit Properties
3. Properties panel:
   - Text input for topic
   - Icon selector (dropdown with previews)
   - Role multi-select
   - Rule text input with autocomplete
4. Validation indicators (red border for errors)

#### **Phase 4: Save & Generate** (Week 3)
1. Save button → POST JSON to `/mindmap_editor/save`
2. Controller: Convert JSON → XML, save to `index.mm`
3. Run `rake jinda:update` via system command
4. Return status: files created/updated, errors
5. Display results in UI (toast notification or modal)

#### **Phase 5: Integration** (Week 4)
1. Add to admin menu in mindmap:
   ```
   admins:Admin
     mindmap_editor:Edit Mindmap
       role: admin
       edit: Edit Mindmap (form)
       save: Save Changes (action)
   ```
2. Run `rake jinda:update` to generate menu link
3. Test: Login as admin → see "Edit Mindmap" in menu
4. Full cycle test: Edit → Save → Verify code generation

#### **Phase 6: Advanced Features** (Week 5+)
1. **Smart Input**:
   - Field type dropdown (String, Integer, etc.)
   - Association builder (select model, type: belongs_to/has_many)
   - Validation builder (presence, format, etc.)
2. **Templates**:
   - "New Model" template (auto-adds default fields)
   - "CRUD Service" template (auto-creates new/edit/delete)
3. **Diff View**:
   - Show generated code changes before committing
4. **Undo/Redo**: Track mindmap changes
5. **Export**: Download mindmap as FreeMind .mm file

### 3.6 Testing Strategy

#### **Unit Tests**:
- Converter tests: XML → JSON → XML round-trip
- Validation tests: Invalid JSON rejected
- Permission tests: Non-admin blocked

#### **Integration Tests**:
- Full cycle: Edit → Save → Generate → Verify files
- Test each node type: model, service, role
- Test options: role, rule, icon

#### **Manual Testing** (in `test/dummy`):
1. Edit existing model (add field) → Save → Check model file
2. Add new service → Save → Check controller file, views
3. Change role → Save → Check menu visibility
4. Invalid input → Verify error message

---

## 4. Challenges and Solutions

### 4.1 Challenge: XML/JSON Mapping Accuracy
**Risk**: Lose data or corrupt mindmap during conversion
**Solution**:
- Comprehensive converter tests with real-world examples
- Round-trip validation (XML → JSON → XML should match)
- Backup original before save
- Show diff before committing changes

### 4.2 Challenge: Large Mindmaps Performance
**Risk**: Browser slowdown with 100+ nodes
**Solution**:
- jsMind supports large trees (tested up to 1000 nodes)
- Lazy loading: Collapse branches by default
- Search/filter feature to find nodes quickly

### 4.3 Challenge: Preserving Custom Code
**Risk**: User's manual code outside jinda markers lost
**Solution**:
- jinda already handles this: only regenerate between markers
- Converter doesn't touch model/controller files directly
- Only updates `index.mm`, then `rake jinda:update` respects markers

### 4.4 Challenge: Real-time Validation
**Risk**: User saves invalid mindmap, breaks generation
**Solution**:
- Client-side: Basic structure validation before save
- Server-side: Comprehensive validation, rollback on error
- Dry-run mode: Test generation without committing
- Clear error messages with node ID reference

---

## 5. Next Steps

### Immediate Actions:
1. ✅ Read and understand AGENTS.md, jinda_flow.md, jinda_mindmap_manual.txt
2. ✅ Analyze jinda.png and lib/jinda/ code
3. ✅ Document current system understanding
4. ⏭️ Create working prototype in test/dummy
   - Start with Phase 1: Setup jsMind
   - Implement basic XML → JSON converter
   - Display current mindmap (read-only)

### Questions to Resolve:
1. Should jinda_mindmap be part of jinda gem or separate gem?
   - **Recommendation**: Part of jinda, installed by default
2. Should it use asset pipeline or Webpacker?
   - **Recommendation**: Asset pipeline (simpler, no Node.js dependency)
3. Should save be auto-save or manual?
   - **Recommendation**: Manual save with "Save" button (user control)
4. Should code generation be automatic or triggered?
   - **Recommendation**: Triggered (show results before applying)

---

## 6. Success Criteria

✅ **MVP (Minimum Viable Product)**:
- Display current mindmap visually
- Edit node text (models, services, roles)
- Add/delete nodes
- Save changes to index.mm
- Run rake jinda:update successfully
- Admin-only access

🎯 **Full Feature Set**:
- Icon selector with preview
- Role/rule dropdowns
- Field type selector for models
- Service workflow builder
- Validation with error messages
- Diff view before save
- Undo/redo
- Templates for common patterns

---

## 7. File Structure

```
test/dummy/  (development location)
├── app/
│   ├── controllers/
│   │   └── mindmap_editor_controller.rb
│   ├── views/
│   │   └── mindmap_editor/
│   │       └── edit.html.erb
│   └── assets/
│       └── javascripts/
│           └── mindmap_editor.js
└── lib/
    └── jinda/
        └── mindmap_converter.rb

# After stable, sync to gem:
jinda/
├── lib/
│   └── generators/
│       └── jinda/
│           └── templates/
│               ├── app/
│               │   ├── controllers/
│               │   │   └── mindmap_editor_controller.rb
│               │   ├── views/
│               │   │   └── mindmap_editor/
│               │   └── assets/
│               │       └── javascripts/
│               └── lib/
│                   └── jinda/
│                       └── mindmap_converter.rb
```

---

## Conclusion

The jinda_mindmap project is well-scoped and achievable. The current system is well-documented through code, and the visual representation in jinda.png clearly shows the structure. By leveraging jsMind and following Rails conventions, we can create a powerful in-app editor that maintains Jinda's mindmap-centric philosophy while improving usability.

The phased approach ensures we deliver value incrementally:
1. Phase 1-2: Prove technical feasibility (converters work)
2. Phase 3-4: Deliver MVP (basic editing + save)
3. Phase 5-6: Polish UX (smart inputs, validation, templates)

Ready to begin Phase 1 implementation.
