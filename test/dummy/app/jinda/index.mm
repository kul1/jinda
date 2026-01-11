<?xml version='1.0' encoding='UTF-8'?>
<map version='1.0.1'>
  <node TEXT='Jinda' ID='ID_1098419600' CREATED='1768079115266' MODIFIED='1768079115266'>
    <node TEXT='services' ID='ID_282419531' POSITION='right' CREATED='1768079115266' MODIFIED='1768079115266'>
      <node TEXT='users:User' ID='ID_1720745721' CREATED='1768079115266' MODIFIED='1768079115266'>
        <node TEXT='role: m' ID='ID_768263176' CREATED='1768079115266' MODIFIED='1768079115266'/>
        <node TEXT='link:info: /users' ID='ID_1266797279' CREATED='1768079115266' MODIFIED='1768079115266'/>
        <node TEXT='link:pending tasks: /jinda/pending' ID='ID_189841353' CREATED='1768079115266' MODIFIED='1768079115266'/>
        <node TEXT='user:edit' ID='ID_154000410' CREATED='1768079115266' MODIFIED='1768079115266'>
          <node TEXT='enter_user:edit' ID='ID_1108188320' CREATED='1768079115266' MODIFIED='1768079115266'>
            <icon BUILTIN='attach'/>
            <node TEXT='rule: login? &amp;&amp; own_xmain?' ID='ID_533709421' CREATED='1768079115266' MODIFIED='1768079115266'/>
          </node>
          <node TEXT='update_user' ID='ID_1221806432' CREATED='1768079115266' MODIFIED='1768079115266'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
        <node TEXT='pwd:change password' ID='ID_1382277695' CREATED='1768079115266' MODIFIED='1768079115266'>
          <node TEXT='enter: edit' ID='ID_1559014937' CREATED='1768079115266' MODIFIED='1768079115266'>
            <icon BUILTIN='attach'/>
            <node TEXT='rule: login? &amp;&amp; own_xmain?' ID='ID_428909911' CREATED='1768079115266' MODIFIED='1768079115266'/>
          </node>
          <node TEXT='change_password' ID='ID_1566171053' CREATED='1768079115266' MODIFIED='1768079115266'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
      </node>
      <node TEXT='admins:Admin' ID='ID_1348489452' CREATED='1768079115267' MODIFIED='1768079115267'>
        <node TEXT='role: a' ID='ID_494507021' CREATED='1768079115267' MODIFIED='1768079115267'/>
        <node TEXT='edit_role:edit user role' ID='ID_1213363124' CREATED='1768079115267' MODIFIED='1768079115267'>
          <node TEXT='select_user:select user' ID='ID_1190117882' CREATED='1768079115267' MODIFIED='1768079115267'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: a' ID='ID_801833906' CREATED='1768079115267' MODIFIED='1768079115267'/>
          </node>
          <node TEXT='edit_role:edit role' ID='ID_1325872490' CREATED='1768079115267' MODIFIED='1768079115267'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: a' ID='ID_878805165' CREATED='1768079115267' MODIFIED='1768079115267'/>
          </node>
          <node TEXT='update_role' ID='ID_1709875397' CREATED='1768079115267' MODIFIED='1768079115267'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
        <node TEXT='link: pending tasks: /jinda/pending' ID='ID_1088166839' CREATED='1768079115267' MODIFIED='1768079115267'/>
        <node TEXT='link: logs: /jinda/logs' ID='ID_829325467' CREATED='1768079115267' MODIFIED='1768079115267'/>
        <node TEXT='link: docs: /jinda/doc' ID='ID_351025910' CREATED='1768079115267' MODIFIED='1768079115267'/>
        <node TEXT='link: Mindmap Editor: /mindmap_editor/edit' ID='ID_999999999' CREATED='1768079115267' MODIFIED='1768079115267'/>
      </node>
      <node TEXT='devs: Developer' ID='ID_1003882979' CREATED='1768079115267' MODIFIED='1768079115267'>
        <node TEXT='role: d' ID='ID_243826735' CREATED='1768079115267' MODIFIED='1768079115267'/>
        <node TEXT='link: error_logs: /jinda/error_logs' ID='ID_716276608' CREATED='1768079115267' MODIFIED='1768079115267'/>
        <node TEXT='link: notice_logs: /jinda/notice_logs' ID='ID_1570419198' CREATED='1768079115267' MODIFIED='1768079115267'/>
      </node>
      <node TEXT='docs: Document' ID='ID_853155456' CREATED='1768079115267' MODIFIED='1768079115267'>
        <node TEXT='link: My Document: /docs/my' ID='ID_1938238774' CREATED='1768079115267' MODIFIED='1768079115267'>
          <node TEXT='role: m' ID='ID_756693571' CREATED='1768079115267' MODIFIED='1768079115267'/>
        </node>
        <node TEXT='doc_new: New Document' ID='ID_899042293' CREATED='1768079115267' MODIFIED='1768079115267'>
          <node TEXT='doc_form: Doc Form' ID='ID_1840278804' CREATED='1768079115267' MODIFIED='1768079115267'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_710001492' CREATED='1768079115267' MODIFIED='1768079115267'/>
          </node>
          <node TEXT='doc_update: Doc update' ID='ID_1352102524' CREATED='1768079115267' MODIFIED='1768079115267'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
        <node TEXT='doc_edit: Edit Document' ID='ID_339628868' CREATED='1768079115267' MODIFIED='1768079115267'>
          <icon BUILTIN='button_cancel'/>
          <node TEXT='doc_select: Select Document' ID='ID_801950372' CREATED='1768079115267' MODIFIED='1768079115267'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_874064541' CREATED='1768079115267' MODIFIED='1768079115267'/>
          </node>
          <node TEXT='doc_edit: Edit Document' ID='ID_1190499756' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_581865685' CREATED='1768079115268' MODIFIED='1768079115268'/>
          </node>
          <node TEXT='doc_update: Doc_update' ID='ID_447781815' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
        <node TEXT='doc_xedit: Doc_hidden_menu' ID='ID_278169779' CREATED='1768079115268' MODIFIED='1768079115268'>
          <icon BUILTIN='button_cancel'/>
          <node TEXT='doc_edit: Edit' ID='ID_541432768' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_378396665' CREATED='1768079115268' MODIFIED='1768079115268'/>
          </node>
          <node TEXT='doc_update: Doc_update' ID='ID_802199910' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
      </node>
      <node TEXT='notes: Notes' ID='ID_554831343' CREATED='1768079115268' MODIFIED='1768079115268'>
        <node TEXT='link:My Notes: /notes/my' ID='ID_737469676' CREATED='1768079115268' MODIFIED='1768079115268'>
          <node TEXT='role: m' ID='ID_625444137' CREATED='1768079115268' MODIFIED='1768079115268'/>
        </node>
        <node TEXT='new: New Note' ID='ID_553734932' CREATED='1768079115268' MODIFIED='1768079115268'>
          <node TEXT='new_note: New ' ID='ID_723334321' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_402111407' CREATED='1768079115268' MODIFIED='1768079115268'/>
          </node>
          <node TEXT='create: Create' ID='ID_1125779183' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='bookmark'/>
          </node>
          <node TEXT='/notes/my' ID='ID_985992723' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='forward'/>
          </node>
        </node>
        <node TEXT='edit: Edit' ID='ID_1241171950' CREATED='1768079115268' MODIFIED='1768079115268'>
          <node TEXT='select_note: Select' ID='ID_1790163920' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_690868886' CREATED='1768079115268' MODIFIED='1768079115268'/>
          </node>
          <node TEXT='edit_note: Edit' ID='ID_938262436' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_751648640' CREATED='1768079115268' MODIFIED='1768079115268'/>
          </node>
          <node TEXT='update: Update' ID='ID_1581002301' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
        <node TEXT='delete:Delete' ID='ID_320521408' CREATED='1768079115268' MODIFIED='1768079115268'>
          <node TEXT='select_note: Select' ID='ID_1631275659' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_709013767' CREATED='1768079115268' MODIFIED='1768079115268'/>
          </node>
          <node TEXT='delete: Delete' ID='ID_1347765598' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
        <node TEXT='mail: Mail' ID='ID_1325232876' CREATED='1768079115268' MODIFIED='1768079115268'>
          <node TEXT='select_note: Select' ID='ID_1817148049' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_203526506' CREATED='1768079115268' MODIFIED='1768079115268'/>
          </node>
          <node TEXT='display_mail: Dsiplay Mail' ID='ID_379926448' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='attach'/>
          </node>
          <node TEXT='mail: Mail' ID='ID_1981382192' CREATED='1768079115268' MODIFIED='1768079115268'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
        <node TEXT='xedit: Future use' ID='ID_807216843' CREATED='1768079115268' MODIFIED='1768079115268'>
          <icon BUILTIN='button_cancel'/>
          <node TEXT='edit_note: Edit' ID='ID_6864095' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_578610352' CREATED='1768079115269' MODIFIED='1768079115269'/>
          </node>
          <node TEXT='update: Update' ID='ID_1206027492' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
      </node>
      <node TEXT='articles: Article' ID='ID_328863650' CREATED='1768079115269' MODIFIED='1768079115269'>
        <node TEXT='link: All Articles: /articles' ID='ID_1521905276' CREATED='1768079115269' MODIFIED='1768079115269'/>
        <node TEXT='link: My article: /articles/my' ID='ID_1376361427' CREATED='1768079115269' MODIFIED='1768079115269'>
          <node TEXT='role: m' ID='ID_368022901' CREATED='1768079115269' MODIFIED='1768079115269'/>
        </node>
        <node TEXT='new_article: New Article' ID='ID_1355420049' CREATED='1768079115269' MODIFIED='1768079115269'>
          <node TEXT='form_article: New Article' ID='ID_1468250197' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_739074930' CREATED='1768079115269' MODIFIED='1768079115269'/>
          </node>
          <node TEXT='create: Create Article' ID='ID_1687683396' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='bookmark'/>
          </node>
          <node TEXT='/articles/my' ID='ID_657878492' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='forward'/>
          </node>
        </node>
        <node TEXT='edit_article: Edit Article' ID='ID_922854639' CREATED='1768079115269' MODIFIED='1768079115269'>
          <node TEXT='select_article: Select Article' ID='ID_938626803' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_476262946' CREATED='1768079115269' MODIFIED='1768079115269'/>
          </node>
          <node TEXT='edit_article: Edit Article' ID='ID_661682947' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_530638093' CREATED='1768079115269' MODIFIED='1768079115269'/>
          </node>
          <node TEXT='j_update: Update Article' ID='ID_1575963748' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='bookmark'/>
          </node>
          <node TEXT='/articles/my' ID='ID_863187878' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='forward'/>
          </node>
        </node>
        <node TEXT='xedit_article: xEdit Article' ID='ID_1861034169' CREATED='1768079115269' MODIFIED='1768079115269'>
          <icon BUILTIN='button_cancel'/>
          <node TEXT='edit_article: Edit Article' ID='ID_91386173' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_700393369' CREATED='1768079115269' MODIFIED='1768079115269'/>
          </node>
          <node TEXT='j_update: Update Article' ID='ID_1635586443' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
      </node>
      <node TEXT='comments: Comment' ID='ID_704959130' CREATED='1768079115269' MODIFIED='1768079115269'>
        <icon BUILTIN='button_cancel'/>
        <node TEXT='role: m' ID='ID_310744069' CREATED='1768079115269' MODIFIED='1768079115269'/>
        <node TEXT='new_comment: New Comment' ID='ID_1973520751' CREATED='1768079115269' MODIFIED='1768079115269'>
          <icon BUILTIN='button_cancel'/>
          <node TEXT='create' ID='ID_345629058' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='bookmark'/>
            <node TEXT='role: m' ID='ID_737983677' CREATED='1768079115269' MODIFIED='1768079115269'/>
          </node>
          <node TEXT='/articles/my' ID='ID_170265872' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='forward'/>
          </node>
        </node>
        <node TEXT='comments: Comment' ID='ID_298151177' CREATED='1768079115269' MODIFIED='1768079115269'>
          <icon BUILTIN='button_cancel'/>
          <node TEXT='role: m' ID='ID_576395977' CREATED='1768079115269' MODIFIED='1768079115269'/>
          <node TEXT='new_comment: New Comment' ID='ID_1683596181' CREATED='1768079115269' MODIFIED='1768079115269'>
            <icon BUILTIN='button_cancel'/>
            <node TEXT='create' ID='ID_933207888' CREATED='1768079115269' MODIFIED='1768079115269'>
              <icon BUILTIN='bookmark'/>
              <node TEXT='role: m' ID='ID_295656570' CREATED='1768079115269' MODIFIED='1768079115269'/>
            </node>
            <node TEXT='/articles/my' ID='ID_1293153336' CREATED='1768079115270' MODIFIED='1768079115270'>
              <icon BUILTIN='forward'/>
            </node>
          </node>
        </node>
      </node>
      <node TEXT='ctrs: ctrs&amp; Menu' ID='ID_1495015891' CREATED='1768079115270' MODIFIED='1768079115270'>
        <node TEXT='role: a' ID='ID_381986102' CREATED='1768079115270' MODIFIED='1768079115270'/>
        <node TEXT='vfolder1:Sub Menu 1' ID='ID_1960607342' CREATED='1768079115270' MODIFIED='1768079115270'>
          <node TEXT='viewfile1: Title 1' ID='ID_328242903' CREATED='1768079115270' MODIFIED='1768079115270'>
            <icon BUILTIN='attach'/>
            <node TEXT='rule: login? &amp;&amp; own_xmain?' ID='ID_543763780' CREATED='1768079115270' MODIFIED='1768079115270'/>
          </node>
          <node TEXT='viewfile2: Title 2' ID='ID_1316819449' CREATED='1768079115270' MODIFIED='1768079115270'>
            <icon BUILTIN='attach'/>
            <node TEXT='rule: login? &amp;&amp; own_xmain?' ID='ID_719266662' CREATED='1768079115270' MODIFIED='1768079115270'/>
          </node>
          <node TEXT='update_viewfile1' ID='ID_171099141' CREATED='1768079115270' MODIFIED='1768079115270'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
        <node TEXT='vfolder2:Title 2' ID='ID_914236141' CREATED='1768079115270' MODIFIED='1768079115270'>
          <node TEXT='viewfile2: Title 2' ID='ID_1222970183' CREATED='1768079115270' MODIFIED='1768079115270'>
            <icon BUILTIN='attach'/>
            <node TEXT='rule: login? &amp;&amp; own_xmain?' ID='ID_297883755' CREATED='1768079115270' MODIFIED='1768079115270'/>
          </node>
        </node>
      </node>
      <node TEXT='sitemap: Sitemap' ID='ID_925257043' CREATED='1768079115270' MODIFIED='1768079115270'>
        <node TEXT='role: a' ID='ID_852156859' CREATED='1768079115270' MODIFIED='1768079115270'/>
        <node TEXT='sitemap: Sitemap' ID='ID_961056168' CREATED='1768079115270' MODIFIED='1768079115270'/>
      </node>
      <node TEXT='api/v1/notes: Notes API ' ID='ID_35210833' CREATED='1768079115270' MODIFIED='1768079115270'>
        <node TEXT='link:My Notes: /api/v1/notes/my' ID='ID_1053900670' CREATED='1768079115270' MODIFIED='1768079115270'>
          <icon BUILTIN='button_cancel'/>
          <node TEXT='role: m' ID='ID_456258534' CREATED='1768079115270' MODIFIED='1768079115270'/>
        </node>
        <node TEXT='new: New Note' ID='ID_1182560700' CREATED='1768079115270' MODIFIED='1768079115270'>
          <node TEXT='new_note: New ' ID='ID_840380967' CREATED='1768079115270' MODIFIED='1768079115270'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_413372195' CREATED='1768079115270' MODIFIED='1768079115270'/>
          </node>
          <node TEXT='create: Create' ID='ID_924027059' CREATED='1768079115270' MODIFIED='1768079115270'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
        <node TEXT='edit: Edit' ID='ID_963001770' CREATED='1768079115271' MODIFIED='1768079115271'>
          <node TEXT='edit_note: Edit' ID='ID_1362613316' CREATED='1768079115271' MODIFIED='1768079115271'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_651730297' CREATED='1768079115271' MODIFIED='1768079115271'/>
          </node>
          <node TEXT='update: Update' ID='ID_1445882396' CREATED='1768079115271' MODIFIED='1768079115271'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
        <node TEXT='delete:Delete' ID='ID_918406528' CREATED='1768079115271' MODIFIED='1768079115271'>
          <node TEXT='select_note: Select' ID='ID_809771470' CREATED='1768079115271' MODIFIED='1768079115271'>
            <icon BUILTIN='attach'/>
            <node TEXT='role: m' ID='ID_730425426' CREATED='1768079115271' MODIFIED='1768079115271'/>
          </node>
          <node TEXT='delete: Delete' ID='ID_506410154' CREATED='1768079115271' MODIFIED='1768079115271'>
            <icon BUILTIN='bookmark'/>
          </node>
        </node>
      </node>
    </node>
    <node TEXT='roles' ID='ID_855471610' POSITION='right' CREATED='1768079115271' MODIFIED='1768079115271'>
      <node TEXT='m: member' ID='ID_1681080231' CREATED='1768079115271' MODIFIED='1768079115271'/>
      <node TEXT='a: admin' ID='ID_1429503284' CREATED='1768079115271' MODIFIED='1768079115271'/>
      <node TEXT='d: developer' ID='ID_568365839' CREATED='1768079115271' MODIFIED='1768079115271'/>
    </node>
    <node TEXT='models' ID='ID_1677010054' POSITION='right' CREATED='1768079115271' MODIFIED='1768079115271'>
      <node TEXT='person' ID='ID_1957754752' CREATED='1768079115271' MODIFIED='1768079115271'>
        <node TEXT='fname' ID='ID_1617970069' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='lname' ID='ID_1200135538' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='sex: integer' ID='ID_1770958985' CREATED='1768079115271' MODIFIED='1768079115271'>
          <node TEXT='1: male' ID='ID_793089342' CREATED='1768079115271' MODIFIED='1768079115271'/>
          <node TEXT='2: female' ID='ID_1796007763' CREATED='1768079115271' MODIFIED='1768079115271'/>
        </node>
        <node TEXT='belongs_to :address' ID='ID_1509464300' CREATED='1768079115271' MODIFIED='1768079115271'>
          <icon BUILTIN='edit'/>
        </node>
        <node TEXT='dob: date' ID='ID_604231613' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='phone' ID='ID_936807610' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='photo' ID='ID_1957301629' CREATED='1768079115271' MODIFIED='1768079115271'/>
      </node>
      <node TEXT='address' ID='ID_959987887' CREATED='1768079115271' MODIFIED='1768079115271'>
        <node TEXT='address_street' ID='ID_430517150' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='city' ID='ID_1797865138' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='state' ID='ID_1964490487' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='zip' ID='ID_1226075540' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='phone' ID='ID_65427990' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='lat: float' ID='ID_1859608350' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='lng: float' ID='ID_48497260' CREATED='1768079115271' MODIFIED='1768079115271'/>
      </node>
      <node TEXT='article' ID='ID_1995497233' CREATED='1768079115271' MODIFIED='1768079115271'>
        <node TEXT='title' ID='ID_364756011' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='text' ID='ID_1676483995' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='belongs_to :user, :class_name =&gt; &quot;User&quot;' ID='ID_1334057464' CREATED='1768079115271' MODIFIED='1768079115271'>
          <icon BUILTIN='edit'/>
        </node>
        <node TEXT='has_many :comments' ID='ID_408271104' CREATED='1768079115271' MODIFIED='1768079115271'>
          <icon BUILTIN='edit'/>
        </node>
        <node TEXT='validates :title, :text, :user_id, presence: true' ID='ID_944554146' CREATED='1768079115271' MODIFIED='1768079115271'>
          <icon BUILTIN='edit'/>
        </node>
        <node TEXT='body' ID='ID_229502630' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='keywords' ID='ID_404103076' CREATED='1768079115271' MODIFIED='1768079115271'/>
      </node>
      <node TEXT='picture' ID='ID_864577403' CREATED='1768079115271' MODIFIED='1768079115271'>
        <node TEXT='picture' ID='ID_679208099' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='description' ID='ID_1266154874' CREATED='1768079115271' MODIFIED='1768079115271'/>
        <node TEXT='belongs_to :user' ID='ID_1422817360' CREATED='1768079115272' MODIFIED='1768079115272'>
          <icon BUILTIN='edit'/>
        </node>
      </node>
      <node TEXT='note' ID='ID_1450593753' CREATED='1768079115272' MODIFIED='1768079115272'>
        <node TEXT='include Mongoid::Attributes::Dynamic' ID='ID_537548385' CREATED='1768079115272' MODIFIED='1768079115272'>
          <icon BUILTIN='edit'/>
        </node>
        <node TEXT='title' ID='ID_1611227370' CREATED='1768079115272' MODIFIED='1768079115272'/>
        <node TEXT='body' ID='ID_88547965' CREATED='1768079115272' MODIFIED='1768079115272'/>
        <node TEXT='belongs_to :user' ID='ID_1655403736' CREATED='1768079115272' MODIFIED='1768079115272'>
          <icon BUILTIN='edit'/>
        </node>
        <node TEXT='before_validation :ensure_title_has_a_value ' ID='ID_1934899110' CREATED='1768079115272' MODIFIED='1768079115272'>
          <icon BUILTIN='edit'/>
        </node>
        <node TEXT='validates :title, length: { maximum: (MAX_TITLE_LENGTH = 30), message: &quot;Must be less   than 30 characters&quot; }, presence: true' ID='ID_1430552418' CREATED='1768079115272' MODIFIED='1768079115272'>
          <icon BUILTIN='edit'/>
        </node>
        <node TEXT='validates :body, length: { maximum: (MAX_BODY_LENGTH = 1000), message: &quot;Must be less   than 1000 characters&quot;} ' ID='ID_1231500988' CREATED='1768079115272' MODIFIED='1768079115272'>
          <icon BUILTIN='edit'/>
        </node>
        <node TEXT='private
  def ensure_title_has_a_value
    if title.blank?
      self.title = body[0..(MAX_TITLE_LENGTH-1)] unless body.blank?
    end
  end
  
' ID='ID_1069060625' CREATED='1768079115272' MODIFIED='1768079115272'>
          <icon BUILTIN='edit'/>
        </node>
      </node>
      <node TEXT='comment' ID='ID_429078131' CREATED='1768079115272' MODIFIED='1768079115272'>
        <node TEXT='body' ID='ID_1251093062' CREATED='1768079115272' MODIFIED='1768079115272'/>
        <node TEXT='belongs_to :article, :class_name =&gt; &quot;Article&quot;  ' ID='ID_911071644' CREATED='1768079115272' MODIFIED='1768079115272'>
          <icon BUILTIN='edit'/>
        </node>
        <node TEXT='belongs_to :user, :class_name =&gt; &quot;User&quot;  ' ID='ID_588013696' CREATED='1768079115272' MODIFIED='1768079115272'>
          <icon BUILTIN='edit'/>
        </node>
        <node TEXT='belongs_to :job, :class_name =&gt; &quot;Job&quot;  ' ID='ID_31602545' CREATED='1768079115272' MODIFIED='1768079115272'>
          <icon BUILTIN='edit'/>
        </node>
        <node TEXT='belongs_to :commentable, polymorphic: true ' ID='ID_1288333428' CREATED='1768079115272' MODIFIED='1768079115272'>
          <icon BUILTIN='edit'/>
        </node>
        <node TEXT='index({ commentable_id: 1, commentable_type: 1}) ' ID='ID_598892151' CREATED='1768079115272' MODIFIED='1768079115272'>
          <icon BUILTIN='edit'/>
        </node>
      </node>
    </node>
  </node>
</map>