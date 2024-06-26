<map version="freeplane 1.11.5">
<!--To view this file, download free mind mapping software Freeplane from https://www.freeplane.org -->
<node TEXT="Jinda" FOLDED="false" ID="ID_1098419600" CREATED="1273819432637" MODIFIED="1334737006485"><hook NAME="MapStyle">
    <properties edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff" fit_to_viewport="false"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="bottom_or_right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ID="ID_271890427" ICON_SIZE="12 pt" COLOR="#000000" STYLE="fork">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="2" TRANSPARENCY="200" DASH="" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_271890427" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
<richcontent TYPE="DETAILS" CONTENT-TYPE="plain/auto"/>
<richcontent TYPE="NOTE" CONTENT-TYPE="plain/auto"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes">
<font SIZE="9"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#000000" BACKGROUND_COLOR="#ffffff" TEXT_ALIGN="LEFT"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.selection" BACKGROUND_COLOR="#afd3f7" BORDER_COLOR_LIKE_EDGE="false" BORDER_COLOR="#afd3f7"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="bottom_or_right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important" ID="ID_67550811">
<icon BUILTIN="yes"/>
<arrowlink COLOR="#003399" TRANSPARENCY="255" DESTINATION="ID_67550811"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="bottom_or_right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000" STYLE="oval" SHAPE_HORIZONTAL_MARGIN="10 pt" SHAPE_VERTICAL_MARGIN="10 pt">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,5"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,6"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,7"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,8"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,9"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,10"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,11"/>
</stylenode>
</stylenode>
</map_styles>
</hook>
<node TEXT="services" POSITION="bottom_or_right" ID="ID_282419531" CREATED="1273819462973" MODIFIED="1589756758387">
<node TEXT="users:User" FOLDED="true" ID="ID_1720745721" CREATED="1275756501221" MODIFIED="1583097151076">
<node TEXT="role:m" ID="ID_1662699954" CREATED="1278491598711" MODIFIED="1494393920347"/>
<node TEXT="link:info: /users" ID="ID_1266797279" CREATED="1279700865182" MODIFIED="1357798847781"/>
<node TEXT="link:pending tasks: /jinda/pending" ID="ID_189841353" CREATED="1319015338880" MODIFIED="1528215866339"/>
<node TEXT="user:edit" ID="ID_154000410" CREATED="1275905802131" MODIFIED="1355422418892">
<node TEXT="enter_user:edit" ID="ID_1108188320" CREATED="1275756515843" MODIFIED="1330477833918">
<icon BUILTIN="attach"/>
<node TEXT="rule:login? &amp;&amp; own_xmain?" ID="ID_1767357871" CREATED="1282816887988" MODIFIED="1282817769412"/>
</node>
<node TEXT="update_user" ID="ID_1221806432" CREATED="1275756530989" MODIFIED="1282822205361">
<icon BUILTIN="bookmark"/>
</node>
</node>
<node TEXT="pwd:change password" ID="ID_1382277695" CREATED="1275756504750" MODIFIED="1355422424108">
<node TEXT="enter: edit" ID="ID_1559014937" CREATED="1275756515843" MODIFIED="1330477842311">
<icon BUILTIN="attach"/>
<node TEXT="rule:login? &amp;&amp; own_xmain?" ID="ID_2948144" CREATED="1282816887988" MODIFIED="1282817769412"/>
</node>
<node TEXT="change_password" ID="ID_1566171053" CREATED="1275756530989" MODIFIED="1275756553762">
<icon BUILTIN="bookmark"/>
</node>
</node>
</node>
<node TEXT="admins:Admin" FOLDED="true" ID="ID_1348489452" CREATED="1275752678377" MODIFIED="1602251558474">
<node TEXT="role:a" ID="ID_229996461" CREATED="1275752688167" MODIFIED="1275752690948"/>
<node TEXT="edit_role:edit user role" ID="ID_1213363124" CREATED="1282722836614" MODIFIED="1330477902602">
<node TEXT="select_user:select user" ID="ID_1190117882" CREATED="1282722862918" MODIFIED="1330477922159">
<icon BUILTIN="attach"/>
<node TEXT="role:a" ID="ID_1859523490" CREATED="1282722901932" MODIFIED="1282722903469"/>
</node>
<node TEXT="edit_role:edit role" ID="ID_1325872490" CREATED="1282722868801" MODIFIED="1330477926538">
<icon BUILTIN="attach"/>
<node TEXT="role:a" ID="ID_1992100954" CREATED="1282722901932" MODIFIED="1282722903469"/>
</node>
<node TEXT="update_role" ID="ID_1709875397" CREATED="1282722907306" MODIFIED="1282722922669">
<icon BUILTIN="bookmark"/>
</node>
</node>
<node TEXT="link: pending tasks: /jinda/pending" ID="ID_1088166839" CREATED="1273913393454" MODIFIED="1511159690490"/>
<node TEXT="link: logs: /jinda/logs" ID="ID_829325467" CREATED="1275790679363" MODIFIED="1511159696044"/>
<node TEXT="link: docs: /jinda/doc" ID="ID_351025910" CREATED="1507573166973" MODIFIED="1511159700908"/>
</node>
<node TEXT="devs: Developer" FOLDED="true" ID="ID_1003882979" CREATED="1273706796854" MODIFIED="1602251560242">
<node TEXT="role:d" ID="ID_340725299" CREATED="1275373154914" MODIFIED="1275373158632"/>
<node TEXT="link: error_logs: /jinda/error_logs" ID="ID_716276608" CREATED="1275788317299" MODIFIED="1511159716471"/>
<node TEXT="link: notice_logs: /jinda/notice_logs" ID="ID_1570419198" CREATED="1275788317299" MODIFIED="1587858894833"/>
</node>
<node TEXT="docs: Document" FOLDED="true" ID="ID_853155456" CREATED="1589756777499" MODIFIED="1592785016438">
<node TEXT="link: My Document: /docs/my" ID="ID_1938238774" CREATED="1589757073388" MODIFIED="1589772640862">
<node TEXT="role:m" ID="ID_521286668" CREATED="1589757125861" MODIFIED="1589757136547"/>
</node>
<node TEXT="doc_new: New Document" ID="ID_899042293" CREATED="1589756879955" MODIFIED="1589910229085">
<node TEXT="doc_form: Doc Form" ID="ID_1840278804" CREATED="1589756946117" MODIFIED="1589910235469">
<icon BUILTIN="attach"/>
<node TEXT="role: m" ID="ID_642998203" CREATED="1589757054618" MODIFIED="1589757059003"/>
</node>
<node TEXT="doc_update: Doc update" ID="ID_1352102524" CREATED="1589757264764" MODIFIED="1589772413612">
<icon BUILTIN="bookmark"/>
</node>
</node>
<node TEXT="doc_edit: Edit Document" ID="ID_339628868" CREATED="1493419562726" MODIFIED="1590424956484">
<icon BUILTIN="button_cancel"/>
<node TEXT="doc_select: Select Document" ID="ID_801950372" CREATED="1493419577933" MODIFIED="1590180699851">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_761787946" CREATED="1493479602815" MODIFIED="1493479606921"/>
</node>
<node TEXT="doc_edit: Edit Document" ID="ID_1190499756" CREATED="1493419612720" MODIFIED="1590180735204">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_1216426484" CREATED="1493479557266" MODIFIED="1493479561055"/>
</node>
<node TEXT="doc_update: Doc_update" ID="ID_447781815" CREATED="1581400438157" MODIFIED="1590180242343">
<icon BUILTIN="bookmark"/>
</node>
</node>
<node TEXT="doc_xedit: Doc_hidden_menu" ID="ID_278169779" CREATED="1495246388313" MODIFIED="1590180135106">
<icon BUILTIN="button_cancel"/>
<node TEXT="doc_edit: Edit" ID="ID_541432768" CREATED="1493419612720" MODIFIED="1590180160498">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_1339913531" CREATED="1493479557266" MODIFIED="1493479561055"/>
</node>
<node TEXT="doc_update: Doc_update" ID="ID_802199910" CREATED="1581400438157" MODIFIED="1590180242343">
<icon BUILTIN="bookmark"/>
</node>
</node>
</node>
<node TEXT="notes: Notes" FOLDED="true" ID="ID_554831343" CREATED="1493393619430" MODIFIED="1602251562724">
<node TEXT="link:My Notes: /notes/my" ID="ID_737469676" CREATED="1493489768542" MODIFIED="1589772615102">
<node TEXT="role:m" ID="ID_514416082" CREATED="1493490295677" MODIFIED="1493490302239"/>
</node>
<node TEXT="new: New Note" ID="ID_553734932" CREATED="1493419257021" MODIFIED="1591278856955">
<node TEXT="new_note: New " ID="ID_723334321" CREATED="1493419299004" MODIFIED="1581351169990">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_1009521360" CREATED="1493479075294" MODIFIED="1493479079687"/>
</node>
<node TEXT="create: Create" ID="ID_1125779183" CREATED="1493419491125" MODIFIED="1581180747700">
<icon BUILTIN="bookmark"/>
</node>
<node TEXT="/notes/my" ID="ID_985992723" CREATED="1591278861459" MODIFIED="1591319329198">
<icon BUILTIN="forward"/>
<arrowlink DESTINATION="ID_985992723" STARTINCLINATION="0 pt;0 pt;" ENDINCLINATION="0 pt;0 pt;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<linktarget COLOR="#b0b0b0" DESTINATION="ID_985992723" ENDARROW="Default" ENDINCLINATION="0;0;" ID="Arrow_ID_650435572" SOURCE="ID_985992723" STARTARROW="None" STARTINCLINATION="0;0;"/>
</node>
</node>
<node TEXT="edit: Edit" FOLDED="true" ID="ID_1241171950" CREATED="1493419562726" MODIFIED="1591278847249">
<node TEXT="select_note: Select" ID="ID_1790163920" CREATED="1493419577933" MODIFIED="1581350888992">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_1289003986" CREATED="1493479602815" MODIFIED="1493479606921"/>
</node>
<node TEXT="edit_note: Edit" ID="ID_938262436" CREATED="1493419612720" MODIFIED="1581350996674">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_211108947" CREATED="1493479557266" MODIFIED="1493479561055"/>
</node>
<node TEXT="update: Update" ID="ID_1581002301" CREATED="1493419735921" MODIFIED="1581180869775">
<icon BUILTIN="bookmark"/>
</node>
</node>
<node TEXT="delete:Delete" FOLDED="true" ID="ID_320521408" CREATED="1495246388313" MODIFIED="1591278851391" STYLE="fork">
<edge STYLE="bezier" COLOR="#808080" WIDTH="thin"/>
<node TEXT="select_note: Select" ID="ID_1631275659" CREATED="1493419577933" MODIFIED="1581350942681">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_851238107" CREATED="1493479602815" MODIFIED="1493479606921"/>
</node>
<node TEXT="delete: Delete" ID="ID_1347765598" CREATED="1495246466176" MODIFIED="1581799929028">
<icon BUILTIN="bookmark"/>
</node>
</node>
<node TEXT="mail: Mail" FOLDED="true" ID="ID_1325232876" CREATED="1581531446494" MODIFIED="1591278853597">
<node TEXT="select_note: Select" FOLDED="true" ID="ID_1817148049" CREATED="1493419577933" MODIFIED="1581531563343">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_1650154281" CREATED="1493479602815" MODIFIED="1493479606921"/>
</node>
<node TEXT="display_mail: Dsiplay Mail" ID="ID_379926448" CREATED="1581531468872" MODIFIED="1581564690354">
<icon BUILTIN="attach"/>
</node>
<node TEXT="mail: Mail" ID="ID_1981382192" CREATED="1581564346466" MODIFIED="1581564388041">
<icon BUILTIN="bookmark"/>
</node>
</node>
<node TEXT="xedit: Future use" FOLDED="true" ID="ID_807216843" CREATED="1495246388313" MODIFIED="1590180066630">
<icon BUILTIN="button_cancel"/>
<node TEXT="edit_note: Edit" ID="ID_6864095" CREATED="1493419612720" MODIFIED="1584999031935">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_297597260" CREATED="1493479557266" MODIFIED="1493479561055"/>
</node>
<node TEXT="update: Update" ID="ID_1206027492" CREATED="1581400438157" MODIFIED="1581400464170">
<icon BUILTIN="bookmark"/>
</node>
</node>
</node>
<node TEXT="articles: Article" ID="ID_328863650" CREATED="1493393619430" MODIFIED="1603227923763">
<linktarget COLOR="#b0b0b0" DESTINATION="ID_328863650" ENDARROW="Default" ENDINCLINATION="206;0;" ID="Arrow_ID_1639605095" SOURCE="ID_704959130" STARTARROW="None" STARTINCLINATION="206;0;"/>
<linktarget COLOR="#b0b0b0" DESTINATION="ID_328863650" ENDARROW="Default" ENDINCLINATION="206;0;" ID="Arrow_ID_1178441047" SOURCE="ID_704959130" STARTARROW="None" STARTINCLINATION="206;0;"/>
<node TEXT="link: All Articles: /articles" ID="ID_1521905276" CREATED="1493419096527" MODIFIED="1493478060121"/>
<node TEXT="link: My article: /articles/my" FOLDED="true" ID="ID_1376361427" CREATED="1493489768542" MODIFIED="1589757167952">
<node TEXT="role:m" ID="ID_628476988" CREATED="1493490295677" MODIFIED="1493490302239"/>
</node>
<node TEXT="new_article: New Article" ID="ID_1355420049" CREATED="1493419257021" MODIFIED="1588619429446">
<node TEXT="form_article: New Article" ID="ID_1468250197" CREATED="1493419299004" MODIFIED="1493419428686">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_1145618514" CREATED="1493479075294" MODIFIED="1493479079687"/>
</node>
<node TEXT="create: Create Article" ID="ID_1687683396" CREATED="1493419491125" MODIFIED="1493483244848">
<icon BUILTIN="bookmark"/>
</node>
<node TEXT="/articles/my" ID="ID_657878492" CREATED="1591278861459" MODIFIED="1591319807025">
<icon BUILTIN="forward"/>
<arrowlink DESTINATION="ID_657878492" STARTINCLINATION="0 pt;0 pt;" ENDINCLINATION="0 pt;0 pt;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<linktarget COLOR="#b0b0b0" DESTINATION="ID_657878492" ENDARROW="Default" ENDINCLINATION="0;0;" ID="Arrow_ID_883618983" SOURCE="ID_657878492" STARTARROW="None" STARTINCLINATION="0;0;"/>
</node>
</node>
<node TEXT="edit_article: Edit Article" ID="ID_922854639" CREATED="1493419562726" MODIFIED="1590180584955">
<node TEXT="select_article: Select Article" ID="ID_938626803" CREATED="1493419577933" MODIFIED="1538329139586">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_753056881" CREATED="1493479602815" MODIFIED="1493479606921"/>
</node>
<node TEXT="edit_article: Edit Article" ID="ID_661682947" CREATED="1493419612720" MODIFIED="1493524438941">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_1681993437" CREATED="1493479557266" MODIFIED="1493479561055"/>
</node>
<node TEXT="j_update: Update Article" ID="ID_1575963748" CREATED="1493419735921" MODIFIED="1593286858918">
<icon BUILTIN="bookmark"/>
</node>
<node TEXT="/articles/my" ID="ID_863187878" CREATED="1591278861459" MODIFIED="1591319807025">
<icon BUILTIN="forward"/>
<arrowlink DESTINATION="ID_863187878" STARTINCLINATION="0 pt;0 pt;" ENDINCLINATION="0 pt;0 pt;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<linktarget COLOR="#b0b0b0" DESTINATION="ID_863187878" ENDARROW="Default" ENDINCLINATION="0;0;" ID="Arrow_ID_604727235" SOURCE="ID_863187878" STARTARROW="None" STARTINCLINATION="0;0;"/>
</node>
</node>
<node TEXT="xedit_article: xEdit Article" ID="ID_1861034169" CREATED="1495246388313" MODIFIED="1585001527103">
<icon BUILTIN="button_cancel"/>
<node TEXT="edit_article: Edit Article" ID="ID_91386173" CREATED="1495246432533" MODIFIED="1495267233398">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_1224073606" CREATED="1495246517185" MODIFIED="1495246522964"/>
</node>
<node TEXT="j_update: Update Article" ID="ID_1635586443" CREATED="1495246466176" MODIFIED="1593286876869">
<icon BUILTIN="bookmark"/>
</node>
</node>
</node>
<node TEXT="comments: Comment" ID="ID_704959130" CREATED="1493664700564" MODIFIED="1603247113420">
<icon BUILTIN="button_cancel"/>
<icon BUILTIN="back"/>
<arrowlink DESTINATION="ID_704959130" STARTINCLINATION="0 pt;0 pt;" ENDINCLINATION="0 pt;0 pt;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<arrowlink DESTINATION="ID_328863650" STARTINCLINATION="116.78741 pt;0 pt;" ENDINCLINATION="116.78741 pt;0 pt;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<arrowlink DESTINATION="ID_328863650" STARTINCLINATION="116.78741 pt;0 pt;" ENDINCLINATION="116.78741 pt;0 pt;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<linktarget COLOR="#b0b0b0" DESTINATION="ID_704959130" ENDARROW="Default" ENDINCLINATION="0;0;" ID="Arrow_ID_1795784656" SOURCE="ID_704959130" STARTARROW="None" STARTINCLINATION="0;0;"/>
<node TEXT="new_comment: New Comment" ID="ID_1973520751" CREATED="1493665155709" MODIFIED="1591392666652">
<icon BUILTIN="button_cancel"/>
<node TEXT="create" ID="ID_345629058" CREATED="1493665192413" MODIFIED="1493665226422">
<icon BUILTIN="bookmark"/>
<node TEXT="role:m" ID="ID_1645532530" CREATED="1493665231940" MODIFIED="1493665237018"/>
</node>
<node TEXT="/articles/my" ID="ID_170265872" CREATED="1591278861459" MODIFIED="1591319807025">
<icon BUILTIN="forward"/>
<arrowlink DESTINATION="ID_170265872" STARTINCLINATION="0 pt;0 pt;" ENDINCLINATION="0 pt;0 pt;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<linktarget COLOR="#b0b0b0" DESTINATION="ID_170265872" ENDARROW="Default" ENDINCLINATION="0;0;" ID="Arrow_ID_1468117" SOURCE="ID_170265872" STARTARROW="None" STARTINCLINATION="0;0;"/>
</node>
</node>
<node TEXT="role:m" ID="ID_1101205873" CREATED="1494393494180" MODIFIED="1495275996686"/>
<node TEXT="comments: Comment" ID="ID_298151177" CREATED="1493664700564" MODIFIED="1603226693472">
<icon BUILTIN="button_cancel"/>
<arrowlink DESTINATION="ID_298151177" STARTINCLINATION="0 pt;0 pt;" ENDINCLINATION="0 pt;0 pt;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<linktarget COLOR="#b0b0b0" DESTINATION="ID_298151177" ENDARROW="Default" ENDINCLINATION="0;0;" ID="Arrow_ID_441433142" SOURCE="ID_298151177" STARTARROW="None" STARTINCLINATION="0;0;"/>
<node TEXT="new_comment: New Comment" ID="ID_1683596181" CREATED="1493665155709" MODIFIED="1591392666652">
<icon BUILTIN="button_cancel"/>
<node TEXT="create" ID="ID_933207888" CREATED="1493665192413" MODIFIED="1493665226422">
<icon BUILTIN="bookmark"/>
<node TEXT="role:m" ID="ID_1008837954" CREATED="1493665231940" MODIFIED="1493665237018"/>
</node>
<node TEXT="/articles/my" ID="ID_1293153336" CREATED="1591278861459" MODIFIED="1591319807025">
<icon BUILTIN="forward"/>
<arrowlink DESTINATION="ID_1293153336" STARTINCLINATION="0 pt;0 pt;" ENDINCLINATION="0 pt;0 pt;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<linktarget COLOR="#b0b0b0" DESTINATION="ID_1293153336" ENDARROW="Default" ENDINCLINATION="0;0;" ID="Arrow_ID_1294102929" SOURCE="ID_1293153336" STARTARROW="None" STARTINCLINATION="0;0;"/>
</node>
</node>
<node TEXT="role:m" ID="ID_738264489" CREATED="1494393494180" MODIFIED="1495275996686"/>
</node>
</node>
<node TEXT="ctrs: ctrs&amp; Menu" FOLDED="true" ID="ID_1495015891" CREATED="1489875563330" MODIFIED="1507248509212">
<node TEXT="role:a" ID="ID_1796125628" CREATED="1489875583646" MODIFIED="1494393464288"/>
<node TEXT="vfolder1:Sub Menu 1" ID="ID_1960607342" CREATED="1275905802131" MODIFIED="1489938927874">
<node TEXT="viewfile1: Title 1" ID="ID_328242903" CREATED="1275756515843" MODIFIED="1489939229748">
<icon BUILTIN="attach"/>
<node TEXT="rule:login? &amp;&amp; own_xmain?" ID="ID_1479413309" CREATED="1282816887988" MODIFIED="1282817769412"/>
</node>
<node TEXT="viewfile2: Title 2" ID="ID_1316819449" CREATED="1275756515843" MODIFIED="1490683859703">
<icon BUILTIN="attach"/>
<node TEXT="rule:login? &amp;&amp; own_xmain?" ID="ID_1510989172" CREATED="1282816887988" MODIFIED="1282817769412"/>
</node>
<node TEXT="update_viewfile1" ID="ID_171099141" CREATED="1275756530989" MODIFIED="1489939276491">
<icon BUILTIN="bookmark"/>
</node>
</node>
<node TEXT="vfolder2:Title 2" ID="ID_914236141" CREATED="1275756504750" MODIFIED="1489939000929">
<node TEXT="viewfile2: Title 2" ID="ID_1222970183" CREATED="1275756515843" MODIFIED="1489939293714">
<icon BUILTIN="attach"/>
<node TEXT="rule:login? &amp;&amp; own_xmain?" ID="ID_1312913420" CREATED="1282816887988" MODIFIED="1282817769412"/>
</node>
</node>
</node>
<node TEXT="sitemap: Sitemap" ID="ID_925257043" CREATED="1494172726642" MODIFIED="1494172755433">
<node TEXT="sitemap: Sitemap" ID="ID_961056168" CREATED="1494172758253" MODIFIED="1494172797972"/>
<node TEXT="role:a" ID="ID_242460166" CREATED="1494393494180" MODIFIED="1494393504971"/>
</node>
<node TEXT="api/v1/notes: Notes API " FOLDED="true" ID="ID_35210833" CREATED="1493393619430" MODIFIED="1591392800862">
<node TEXT="link:My Notes: /api/v1/notes/my" ID="ID_1053900670" CREATED="1493489768542" MODIFIED="1591074318558">
<icon BUILTIN="button_cancel"/>
<node TEXT="role:m" ID="ID_1597553308" CREATED="1493490295677" MODIFIED="1493490302239"/>
</node>
<node TEXT="new: New Note" ID="ID_1182560700" CREATED="1493419257021" MODIFIED="1581180635669">
<node TEXT="new_note: New " ID="ID_840380967" CREATED="1493419299004" MODIFIED="1581351169990">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_10690659" CREATED="1493479075294" MODIFIED="1493479079687"/>
</node>
<node TEXT="create: Create" ID="ID_924027059" CREATED="1493419491125" MODIFIED="1581180747700">
<icon BUILTIN="bookmark"/>
</node>
</node>
<node TEXT="edit: Edit" ID="ID_963001770" CREATED="1493419562726" MODIFIED="1581180788218">
<node TEXT="edit_note: Edit" ID="ID_1362613316" CREATED="1493419612720" MODIFIED="1581350996674">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_1838104057" CREATED="1493479557266" MODIFIED="1493479561055"/>
</node>
<node TEXT="update: Update" ID="ID_1445882396" CREATED="1493419735921" MODIFIED="1581180869775">
<icon BUILTIN="bookmark"/>
</node>
</node>
<node TEXT="delete:Delete" ID="ID_918406528" CREATED="1495246388313" MODIFIED="1581340759604" STYLE="fork">
<edge STYLE="bezier" COLOR="#808080" WIDTH="thin"/>
<node TEXT="select_note: Select" ID="ID_809771470" CREATED="1493419577933" MODIFIED="1581350942681">
<icon BUILTIN="attach"/>
<node TEXT="role:m" ID="ID_1160875526" CREATED="1493479602815" MODIFIED="1493479606921"/>
</node>
<node TEXT="delete: Delete" ID="ID_506410154" CREATED="1495246466176" MODIFIED="1581799929028">
<icon BUILTIN="bookmark"/>
</node>
</node>
</node>
</node>
<node TEXT="roles" FOLDED="true" POSITION="bottom_or_right" ID="ID_855471610" CREATED="1273819465949" MODIFIED="1583097143651">
<node TEXT="m: member" ID="ID_1681080231" CREATED="1273819847470" MODIFIED="1330477307826"/>
<node TEXT="a: admin" ID="ID_1429503284" CREATED="1273819855875" MODIFIED="1330477311102"/>
<node TEXT="d: developer" ID="ID_568365839" CREATED="1273819859775" MODIFIED="1330477315009"/>
</node>
<node TEXT="models" POSITION="top_or_left" ID="ID_1677010054" CREATED="1273819456867" MODIFIED="1602123498759">
<node TEXT="person" FOLDED="true" ID="ID_1957754752" CREATED="1292122118499" MODIFIED="1493705885123">
<node TEXT="fname" ID="ID_1617970069" CREATED="1292122135809" MODIFIED="1332878659106"/>
<node TEXT="lname" ID="ID_1200135538" CREATED="1292122150362" MODIFIED="1332878662388"/>
<node TEXT="sex: integer" ID="ID_1770958985" CREATED="1332876694150" MODIFIED="1332876730552">
<node TEXT="1: male" ID="ID_793089342" CREATED="1332878665790" MODIFIED="1332878668499"/>
<node TEXT="2: female" ID="ID_1796007763" CREATED="1332878669085" MODIFIED="1332878673144"/>
</node>
<node TEXT="belongs_to :address" ID="ID_1509464300" CREATED="1292123322429" MODIFIED="1332878620176">
<icon BUILTIN="edit"/>
</node>
<node TEXT="dob: date" ID="ID_604231613" CREATED="1292122156430" MODIFIED="1292122161324"/>
<node TEXT="phone" ID="ID_936807610" CREATED="1286576968143" MODIFIED="1332878681362"/>
<node TEXT="photo" ID="ID_1957301629" CREATED="1290823140269" MODIFIED="1332878684453"/>
</node>
<node TEXT="address" FOLDED="true" ID="ID_959987887" CREATED="1292122236285" MODIFIED="1493768919147">
<node TEXT="address_street" ID="ID_430517150" CREATED="1292122254622" MODIFIED="1355422372241"/>
<node TEXT="city" ID="ID_1797865138" CREATED="1355422373525" MODIFIED="1355422378352"/>
<node TEXT="state" ID="ID_1964490487" CREATED="1355422378959" MODIFIED="1355422380765"/>
<node TEXT="zip" ID="ID_1226075540" CREATED="1355422381231" MODIFIED="1355422382748"/>
<node TEXT="phone" ID="ID_65427990" CREATED="1332876680122" MODIFIED="1332876682148"/>
<node TEXT="lat: float" ID="ID_1859608350" CREATED="1292243471343" MODIFIED="1310195256623"/>
<node TEXT="lng: float" ID="ID_48497260" CREATED="1292243477436" MODIFIED="1310195262534"/>
</node>
<node TEXT="article" ID="ID_1995497233" CREATED="1493418879485" MODIFIED="1602529325998">
<node TEXT="title" ID="ID_364756011" CREATED="1493418891110" MODIFIED="1493418905253"/>
<node TEXT="text" ID="ID_1676483995" CREATED="1493418906868" MODIFIED="1493418911919"/>
<node TEXT="belongs_to :user, :class_name =&gt; &quot;User&quot;" ID="ID_1334057464" CREATED="1493487131376" MODIFIED="1538328284823">
<icon BUILTIN="edit"/>
</node>
<node TEXT="has_many :comments" ID="ID_408271104" CREATED="1493705838166" MODIFIED="1493705877062">
<icon BUILTIN="edit"/>
</node>
<node TEXT="validates :title, :text, :user_id, presence: true" ID="ID_944554146" CREATED="1493718773517" MODIFIED="1493718808965">
<icon BUILTIN="edit"/>
</node>
<node TEXT="body" ID="ID_229502630" CREATED="1494181636998" MODIFIED="1494181660419"/>
<node TEXT="keywords" ID="ID_404103076" CREATED="1497913676275" MODIFIED="1497913685065"/>
</node>
<node TEXT="picture" FOLDED="true" ID="ID_864577403" CREATED="1494040082403" MODIFIED="1583097161145">
<node TEXT="picture" ID="ID_679208099" CREATED="1494040091583" MODIFIED="1494040119098"/>
<node TEXT="description" ID="ID_1266154874" CREATED="1494040120208" MODIFIED="1494040125130"/>
<node TEXT="belongs_to :user" ID="ID_1422817360" CREATED="1493487131376" MODIFIED="1493487186856">
<icon BUILTIN="edit"/>
</node>
</node>
<node TEXT="note" FOLDED="true" ID="ID_1450593753" CREATED="1581177067029" MODIFIED="1583089083450">
<node TEXT="include Mongoid::Attributes::Dynamic" ID="ID_537548385" CREATED="1581243923100" MODIFIED="1581243965554">
<icon BUILTIN="edit"/>
</node>
<node TEXT="title" ID="ID_1611227370" CREATED="1581177848957" MODIFIED="1581177857470"/>
<node TEXT="body" ID="ID_88547965" CREATED="1581177867775" MODIFIED="1581177883555"/>
<node TEXT="belongs_to :user" ID="ID_1655403736" CREATED="1493643129947" MODIFIED="1493643146424">
<icon BUILTIN="edit"/>
</node>
<node TEXT="before_validation :ensure_title_has_a_value " ID="ID_1934899110" CREATED="1581984419312" MODIFIED="1581985586488">
<icon BUILTIN="edit"/>
</node>
<node TEXT="validates :title, length: { maximum: (MAX_TITLE_LENGTH = 30), message: &quot;Must be less   than 30 characters&quot; }, presence: true" ID="ID_1430552418" CREATED="1581495182445" MODIFIED="1581985664674">
<icon BUILTIN="edit"/>
</node>
<node TEXT="validates :body, length: { maximum: (MAX_BODY_LENGTH = 1000), message: &quot;Must be less   than 1000 characters&quot;} " ID="ID_1231500988" CREATED="1581495221779" MODIFIED="1581985709585">
<icon BUILTIN="edit"/>
</node>
<node TEXT="private&#xa;  def ensure_title_has_a_value&#xa;    if title.blank?&#xa;      self.title = body[0..(MAX_TITLE_LENGTH-1)] unless body.blank?&#xa;    end&#xa;  end&#xa;  &#xa;" ID="ID_1069060625" CREATED="1581986280028" MODIFIED="1581987310544">
<icon BUILTIN="edit"/>
</node>
</node>
<node TEXT="comment" ID="ID_429078131" CREATED="1493418915637" MODIFIED="1602591443455">
<node TEXT="body" ID="ID_1251093062" CREATED="1493418939760" MODIFIED="1493418943423"/>
<node TEXT="belongs_to :article, :class_name =&gt; &quot;Article&quot;  " ID="ID_911071644" CREATED="1493418945686" MODIFIED="1602529513657">
<icon BUILTIN="edit"/>
</node>
<node TEXT="belongs_to :user, :class_name =&gt; &quot;User&quot;  " ID="ID_588013696" CREATED="1493643129947" MODIFIED="1602110865206">
<icon BUILTIN="edit"/>
</node>
<node TEXT="belongs_to :job, :class_name =&gt; &quot;Job&quot;  " ID="ID_31602545" CREATED="1601847760278" MODIFIED="1602110883654">
<icon BUILTIN="edit"/>
</node>
<node TEXT="belongs_to :commentable, polymorphic: true " ID="ID_1288333428" CREATED="1601847760278" MODIFIED="1602591549062">
<icon BUILTIN="edit"/>
</node>
<node TEXT="index({ commentable_id: 1, commentable_type: 1}) " ID="ID_598892151" CREATED="1602591560333" MODIFIED="1602592677709">
<icon BUILTIN="edit"/>
</node>
</node>
</node>
</node>
</map>
