<map version="freeplane 1.3.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node FOLDED="false" ID="ID_1723255651" CREATED="1283093380553" MODIFIED="1435090758190"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <p style="text-align: center">
      config
    </p>
    <p style="text-align: center">
      singleton
    </p>
    <p style="text-align: center">
      module
    </p>
  </body>
</html>
</richcontent>
<hook NAME="MapStyle">
    <properties show_icon_for_attributes="true" show_note_icons="true"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node">
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right">
<stylenode LOCALIZED_TEXT="default" MAX_WIDTH="600" COLOR="#000000" STYLE="as_parent">
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.note"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important">
<icon BUILTIN="yes"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000">
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
</stylenode>
</stylenode>
</map_styles>
</hook>
<hook NAME="AutomaticEdgeColor" COUNTER="9"/>
<node TEXT="setup" POSITION="right" ID="ID_1664622307" CREATED="1434950212290" MODIFIED="1435851409651">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
<edge COLOR="#ff0000"/>
<node TEXT="register module" ID="ID_616217982" CREATED="1434954471397" MODIFIED="1435851401434">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
<node TEXT="src" ID="ID_1828909465" CREATED="1434954459116" MODIFIED="1434954460692"/>
<node TEXT="local" ID="ID_43106765" CREATED="1434954455773" MODIFIED="1434954458563"/>
<node TEXT="global" ID="ID_1994971135" CREATED="1434954452957" MODIFIED="1434954454309"/>
<node TEXT="user" ID="ID_1029665869" CREATED="1434954447862" MODIFIED="1434954452674"/>
</node>
<node TEXT="add special path" ID="ID_1150936606" CREATED="1434970016570" MODIFIED="1435851404671">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="set schema" ID="ID_211971474" CREATED="1434978016874" MODIFIED="1435851407180">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="set data to load" ID="ID_1706793997" CREATED="1435058790456" MODIFIED="1435058801254"/>
</node>
<node TEXT="load" POSITION="right" ID="ID_1153941712" CREATED="1434950227699" MODIFIED="1435754808371">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
<edge COLOR="#00ff00"/>
<node TEXT="init" FOLDED="true" ID="ID_239653484" CREATED="1435051920064" MODIFIED="1435051928414">
<node TEXT="load files" ID="ID_1714159493" CREATED="1435051935433" MODIFIED="1435754646172">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="load web" ID="ID_716599298" CREATED="1435239061133" MODIFIED="1435754632805">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
</node>
<node TEXT="search" FOLDED="true" ID="ID_55114533" CREATED="1434950217578" MODIFIED="1435239027837">
<node TEXT="step through search paths" ID="ID_676070596" CREATED="1434971531266" MODIFIED="1435172289647">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="go into array if it is one" ID="ID_1278007155" CREATED="1434971545146" MODIFIED="1435172295083">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="filter files" ID="ID_236784529" CREATED="1435081754917" MODIFIED="1435239027837">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="use list of found files" ID="ID_1492370648" CREATED="1434972679544" MODIFIED="1435172307248">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="later is dominant" ID="ID_1152981838" CREATED="1434971693208" MODIFIED="1435172309766">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
</node>
<node TEXT="autodetect format" FOLDED="true" ID="ID_369463749" CREATED="1434977238286" MODIFIED="1434977246069">
<node TEXT="by extension" ID="ID_802815" CREATED="1434977246598" MODIFIED="1435754615427">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
<icon BUILTIN="help"/>
</node>
<node TEXT="by content" ID="ID_146799666" CREATED="1434977250495" MODIFIED="1435172315183">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
</node>
<node TEXT="parse formats" FOLDED="true" ID="ID_1589152505" CREATED="1434951943166" MODIFIED="1435081820582">
<node TEXT="js" ID="ID_122533272" CREATED="1434955105921" MODIFIED="1435172324516">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="json" ID="ID_1203862956" CREATED="1434955109802" MODIFIED="1435172327250">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="xml" ID="ID_12275225" CREATED="1434955112089" MODIFIED="1435172330101">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="coffee" ID="ID_1603872250" CREATED="1435172348378" MODIFIED="1435172358409">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="yaml" ID="ID_536219288" CREATED="1434955115017" MODIFIED="1435172332497">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="ini" ID="ID_1984699641" CREATED="1434955116921" MODIFIED="1435175745666">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
</node>
<node TEXT="create origin" FOLDED="true" ID="ID_942747941" CREATED="1435084242992" MODIFIED="1435239341350">
<node TEXT="where data is defined" ID="ID_901556567" CREATED="1435084269497" MODIFIED="1435172370301">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="_uri from original" ID="ID_999236003" CREATED="1435084689147" MODIFIED="1435239341349">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
<node TEXT="_setup reference to search" ID="ID_1840087556" CREATED="1435084768896" MODIFIED="1435172375118">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
</node>
<node TEXT="set origin" FOLDED="true" ID="ID_1734218016" CREATED="1435081804221" MODIFIED="1435754396916">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
<node TEXT="add directory as path" FOLDED="true" ID="ID_1039083888" CREATED="1435081921267" MODIFIED="1435129767589">
<node TEXT="for /*" ID="ID_1871060748" CREATED="1435082021621" MODIFIED="1435082026803"/>
</node>
<node TEXT="add basename as path" FOLDED="true" ID="ID_1885176466" CREATED="1435081943624" MODIFIED="1435129771748">
<node TEXT="for /*" ID="ID_1498975002" CREATED="1435082037134" MODIFIED="1435082043315"/>
<node TEXT="for *.yml" ID="ID_1456363073" CREATED="1435081999337" MODIFIED="1435082009868"/>
</node>
<node TEXT="no additional path" FOLDED="true" ID="ID_78284644" CREATED="1435082198165" MODIFIED="1435082209617">
<node TEXT="for /xxx.*" ID="ID_1217698622" CREATED="1435082209623" MODIFIED="1435082221634"/>
</node>
<node TEXT="filter" ID="ID_1389227401" CREATED="1435238941312" MODIFIED="1435355496113">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
</node>
</node>
<node TEXT="combine" FOLDED="true" ID="ID_733011489" CREATED="1435238930520" MODIFIED="1435355528931">
<icon BUILTIN="button_ok"/>
<icon BUILTIN="100%"/>
<node TEXT="combine into one" FOLDED="true" ID="ID_1975883840" CREATED="1434954979756" MODIFIED="1435084379162">
<node TEXT="order by name" ID="ID_1472536622" CREATED="1435084395297" MODIFIED="1435084426282"/>
<node TEXT="value" ID="ID_1626482834" CREATED="1435084379754" MODIFIED="1435140346049"/>
<node TEXT="origin" ID="ID_1605162870" CREATED="1435084383179" MODIFIED="1435085187067"/>
</node>
<node TEXT="set final data" ID="ID_1739486384" CREATED="1435239016102" MODIFIED="1435239023915"/>
</node>
</node>
<node TEXT="watch" FOLDED="true" POSITION="right" ID="ID_1153329564" CREATED="1435082344270" MODIFIED="1435754658691">
<edge COLOR="#007c00"/>
<node TEXT="set watch on files / directories" ID="ID_775948347" CREATED="1434972771134" MODIFIED="1434972792001"/>
<node TEXT="auto reload on file changes" ID="ID_454819395" CREATED="1434954906988" MODIFIED="1434954920360"/>
</node>
<node TEXT="update" POSITION="right" ID="ID_1648591272" CREATED="1434955180544" MODIFIED="1435082467093">
<edge COLOR="#ff0000"/>
<node TEXT="combine all" ID="ID_1829773707" CREATED="1435082487141" MODIFIED="1435083173044">
<node TEXT="use path" ID="ID_678274919" CREATED="1435082628812" MODIFIED="1435082637485"/>
<node TEXT="changeroot = start of lowest updated element" ID="ID_1666879468" CREATED="1435083057083" MODIFIED="1435085273968"/>
<node TEXT="create new data" ID="ID_144225492" CREATED="1435085227722" MODIFIED="1435085232242"/>
<node TEXT="create new meta" ID="ID_737748298" CREATED="1435083279544" MODIFIED="1435129158686"/>
</node>
<node TEXT="validation" ID="ID_1257364130" CREATED="1435082469903" MODIFIED="1435082474679">
<node TEXT="starting from changeroot" ID="ID_1333421349" CREATED="1434978060033" MODIFIED="1435085283224"/>
</node>
<node TEXT="replace" ID="ID_349651444" CREATED="1435083301896" MODIFIED="1435083304517">
<node TEXT="data" ID="ID_1335253722" CREATED="1435083305485" MODIFIED="1435083307702"/>
<node TEXT="meta" ID="ID_1238434846" CREATED="1435083308531" MODIFIED="1435129135925"/>
</node>
<node TEXT="onChange" ID="ID_1313893978" CREATED="1435085196323" MODIFIED="1435090305836">
<node TEXT="find all with start from changeroot" ID="ID_600326427" CREATED="1435085285477" MODIFIED="1435085350159"/>
<node TEXT="find all which start with changeroot" ID="ID_1105103073" CREATED="1435085362036" MODIFIED="1435085381572"/>
</node>
<node TEXT="onReady or onReload" ID="ID_934473458" CREATED="1435090307050" MODIFIED="1435090329162"/>
</node>
<node TEXT="access parts" FOLDED="true" POSITION="right" ID="ID_1326239621" CREATED="1434950239185" MODIFIED="1434950253954">
<edge COLOR="#ff00ff"/>
<node TEXT="get reference to config or part" ID="ID_266536106" CREATED="1434979803358" MODIFIED="1434979816084"/>
</node>
<node TEXT="events" FOLDED="true" POSITION="right" ID="ID_855223485" CREATED="1434955127962" MODIFIED="1434955168072">
<edge COLOR="#007c7c"/>
<node TEXT="onReady" FOLDED="true" ID="ID_297896753" CREATED="1434979849382" MODIFIED="1434979854297">
<node TEXT="first loading done" ID="ID_1578943956" CREATED="1434979859821" MODIFIED="1434979865609"/>
</node>
<node TEXT="onReload" FOLDED="true" ID="ID_44592344" CREATED="1434955160657" MODIFIED="1434979894184">
<node TEXT="reloaded uri" ID="ID_1827631277" CREATED="1434979869133" MODIFIED="1435039382158"/>
</node>
<node TEXT="onChange" FOLDED="true" ID="ID_988936254" CREATED="1435039305135" MODIFIED="1435039309718">
<node TEXT="changed given path at $path" ID="ID_1784049448" CREATED="1435039311159" MODIFIED="1435039340403"/>
</node>
</node>
<node TEXT="properties" POSITION="left" ID="ID_62069937" CREATED="1434954743432" MODIFIED="1434971662341">
<edge COLOR="#7c007c"/>
<node TEXT="origin[]" ID="ID_948564646" CREATED="1434954743432" MODIFIED="1435129093611"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      paths to search in
    </p>
  </body>
</html>
</richcontent>
<node TEXT="arraytree" ID="ID_1472447050" CREATED="1434971290262" MODIFIED="1435076680847">
<node TEXT="uri" ID="ID_299721938" CREATED="1434970595960" MODIFIED="1434972384273"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      path to load from
    </p>
  </body>
</html>
</richcontent>
<node TEXT="file:///bla..." ID="ID_1387241212" CREATED="1434972411908" MODIFIED="1434972426455">
<node TEXT=".../*" ID="ID_779513710" CREATED="1434972453587" MODIFIED="1435081597459"/>
<node TEXT="/*.yml" ID="ID_1241778950" CREATED="1435081554022" MODIFIED="1435081577941"/>
</node>
<node TEXT="no-protocol = file" ID="ID_1301221852" CREATED="1435129593346" MODIFIED="1435129603518"/>
<node TEXT="http://...." ID="ID_1192323302" CREATED="1434972427107" MODIFIED="1434972443247"/>
<node TEXT="https://" ID="ID_1383922446" CREATED="1434972444372" MODIFIED="1434972448112"/>
</node>
<node TEXT="parser" ID="ID_950826195" CREATED="1435130433130" MODIFIED="1435132728666"/>
<node TEXT="filter" ID="ID_920657767" CREATED="1435076941286" MODIFIED="1435129671982"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      path to use from data
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="path" ID="ID_1328357315" CREATED="1434970096489" MODIFIED="1435076886247"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      path to include into
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="watcher" ID="ID_1391574594" CREATED="1434954544043" MODIFIED="1435077137090"/>
<node TEXT="value" ID="ID_1190430413" CREATED="1435076890863" MODIFIED="1435148305762">
<node TEXT="structure" ID="ID_1243270831" CREATED="1435212666106" MODIFIED="1435212670575"/>
</node>
<node TEXT="meta" ID="ID_1798483731" CREATED="1435083832583" MODIFIED="1435083836820">
<node TEXT="list[]" ID="ID_157379544" CREATED="1435212674001" MODIFIED="1435218927424">
<node TEXT="uri" ID="ID_1642973869" CREATED="1435212677219" MODIFIED="1435214577806"/>
<node TEXT="origin&amp;" ID="ID_183165225" CREATED="1435212689378" MODIFIED="1435218940915"/>
<node TEXT="value" ID="ID_617736026" CREATED="1435214580938" MODIFIED="1435214582686"/>
</node>
</node>
<node TEXT="loaded" ID="ID_1815523501" CREATED="1435754498815" MODIFIED="1435754501895"/>
<node TEXT="lastload" ID="ID_933373101" CREATED="1435076899090" MODIFIED="1435076934007"/>
</node>
</node>
<node TEXT="schema{}" ID="ID_955657676" CREATED="1434977540017" MODIFIED="1435066898233"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      overall schema
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="value{}" ID="ID_907808323" CREATED="1434954530850" MODIFIED="1435140339159"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      overall contents
    </p>
  </body>
</html>
</richcontent>
<node TEXT="structure" ID="ID_1859665177" CREATED="1435085467589" MODIFIED="1435085470817"/>
</node>
<node TEXT="meta{}" ID="ID_1680589828" CREATED="1434954693377" MODIFIED="1435129147096"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      uris of origin data
    </p>
  </body>
</html>
</richcontent>
<node TEXT="list[]" ID="ID_1459780802" CREATED="1434954887965" MODIFIED="1435218973230">
<node TEXT="uri" ID="ID_1485476089" CREATED="1434980044073" MODIFIED="1435214586721"/>
<node TEXT="origin" ID="ID_172827928" CREATED="1434980204727" MODIFIED="1435214589498"/>
<node TEXT="value" ID="ID_877505789" CREATED="1435214589963" MODIFIED="1435214591626"/>
</node>
</node>
<node TEXT="listener{}" ID="ID_1579035308" CREATED="1435085017165" MODIFIED="1435128917984">
<node TEXT="path to monitor[]" ID="ID_754479091" CREATED="1435085090591" MODIFIED="1435085138359">
<node TEXT="callbacs" ID="ID_78002318" CREATED="1435085123864" MODIFIED="1435085134217"/>
</node>
</node>
</node>
<node TEXT="methods" POSITION="left" ID="ID_858223804" CREATED="1434971749831" MODIFIED="1434971762505">
<edge COLOR="#ff6600"/>
<node TEXT="setup" ID="ID_308376703" CREATED="1434972100145" MODIFIED="1434972109476">
<node TEXT="pushOrigin %origin" ID="ID_83998979" CREATED="1434971922428" MODIFIED="1435820143841"/>
<node TEXT="unshiftOrigin %origin" ID="ID_448365571" CREATED="1434971990483" MODIFIED="1435820151291"/>
<node TEXT="register $appname, %config" ID="ID_1845145242" CREATED="1434971788254" MODIFIED="1435059219950">
<node TEXT="basedir" ID="ID_1308626379" CREATED="1435910974182" MODIFIED="1435910976666"/>
<node TEXT="uri" ID="ID_1612490081" CREATED="1435060782040" MODIFIED="1435060820204"/>
<node TEXT="filter" ID="ID_1585327596" CREATED="1435060791096" MODIFIED="1435060794376"/>
<node TEXT="parser" ID="ID_1315572465" CREATED="1435060800489" MODIFIED="1435060802776"/>
<node TEXT="path" ID="ID_1673680746" CREATED="1435060796009" MODIFIED="1435910970880"/>
</node>
<node TEXT="setSchema $path, %schema, cb" ID="ID_449446725" CREATED="1434978358204" MODIFIED="1435837640256"/>
</node>
<node TEXT="load" ID="ID_1517392250" CREATED="1434972124257" MODIFIED="1434972154558">
<node TEXT="init" ID="ID_162156904" CREATED="1435047495336" MODIFIED="1435051683546"/>
<node TEXT="reload" ID="ID_1362619988" CREATED="1435911021196" MODIFIED="1435911023808"/>
</node>
<node TEXT="access" ID="ID_424739444" CREATED="1434978336981" MODIFIED="1434978340050">
<node TEXT="get $path" ID="ID_224187396" CREATED="1434979519955" MODIFIED="1434979524448"/>
<node TEXT="get @path" ID="ID_664843750" CREATED="1434979498780" MODIFIED="1434979519455"/>
</node>
</node>
<node TEXT="events" FOLDED="true" POSITION="left" ID="ID_1253867119" CREATED="1435039347712" MODIFIED="1435039395656">
<edge COLOR="#ffff00"/>
<node TEXT="onReady" ID="ID_52071098" CREATED="1435039354952" MODIFIED="1435039358655"/>
<node TEXT="onReload" ID="ID_982861034" CREATED="1435039359119" MODIFIED="1435039362966"/>
<node TEXT="onChange" ID="ID_1558941014" CREATED="1435039363630" MODIFIED="1435039367194"/>
</node>
</node>
</map>
