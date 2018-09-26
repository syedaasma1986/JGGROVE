
---------------------------------------------------------------------
-- To INSERT Email Template for Accpeted Task Automail

INSERT INTO tblSubHtmlTemplates VALUES
((SELECT MAX(ID) FROM tblSubHtmlTemplates)+1, '111',
'Accepted Task Automail','Task Acceptance Acknowledgement',
'<div style="font-size: 13.3333px;"><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg"' + ' />
</div><div style="font-size: 13.3333px;"><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif"' + ' /></div>',
'<div>
Hi #Fname#,
<br/><br/>
You have accepted the task.
<br/><br/>
Please click or copy below link to view task:
<br/><br/>
<a href="#ParentTaskLink#">#ParentTaskLink#</a>
<br/><br/>
SubTask List
<br/><br/>
#SubTaskLink#
<br/><br/>
Quick View
<br/><br/>
<a href="#QuickViewLink#">#QuickViewLink#</a>
<br/><br/>
View More...
<br/><br/>
<a href="#ViewMoreLink#">#ViewMoreLink#</a>
<br/><br/>
Thanks!</div>',
'<br /><div><p style="font-size: 13.3333px;">J.M. Grove - Construction &amp; Supply&nbsp;<br /><a href=' + '"http://web.jmgrovebuildingsupply.com/Sr_App/jmgroveconstruction.com"' + '>jmgroveconstruction.com&nbsp;</a><br />
<a href=' + '"http://jmgrovebuildingsupply.com/"' + '>http://jmgrovebuildingsupply.com/</a><br />
<a href=' + '"http://web.jmgrovebuildingsupply.com/login.aspx"' + '>http://web.jmgrovebuildingsupply.com/login.aspx</a><br />
<a href=' + '"http://jmgroverealestate.com/"' + '>http://jmgroverealestate.com/</a><br />
<br />72 E Lancaster Ave<br />Malvern, Pa 19355<br />Human Resources<br />Office:(215) 274-5182 Ext. 4<br />
<a href=' + '"mailto:Hr@jmgroveconstruction.com"' + '>Hr@jmgroveconstruction.com</a></p>
<div style="font-size: 13.3333px;"><a href=' + '"https://www.facebook.com/JMGrove1com/"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/fb.png"' + ' />
</a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/tw.png"' + ' />
</a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/236e0d0b-832c-4543-81a6-f6c460d302f0_zpsl4nh3ane.png.html"' + '>
<img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/gpls.png"' + ' /></a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/pinterest_zpspioq6pve.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/pint.png"' + ' /></a><br />
<a href=' + '"http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/hbt.png"' + ' /></a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/youtube_zpsxyhfmm1b.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/yt.png"' + ' /></a>
<a href=' + '"http://s49.photobucket.com/user/jmg1/media/c3894afd-7a37-43e2-917c-5ffb7a5036a2_zpschul0pqd.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/houzz.png"' + ' /></a>&nbsp;
<a href=' + '"http://s49.photobucket.com/user/jmg1/media/4478596b-67f4-444e-992a-624af3e56255_zpsoi8p1uyv.jpg.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/linkin.jpg"' + ' /></a></div>
<div style="font-size: 13.3333px;"><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/footer.png"' + ' /></div></div>',
GETDATE(),NULL)

---------------------------------------------------------------------


---------------------------------------------------------------------
-- To INSERT Email Template for Rejected Task Automail
INSERT INTO tblSubHtmlTemplates VALUES
((SELECT MAX(ID) FROM tblSubHtmlTemplates)+1, '112',
'Rejected Task Automail','Task Rejection Acknowledgement',
'<div style="font-size: 13.3333px;"><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/header.jpg"' + ' />
</div><div style="font-size: 13.3333px;"><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/logo.gif"' + ' /></div>',
'<div>
Hi #Fname#,
<br/><br/>
You have rejected the task.
<br/><br/>
Please click or copy below link to view task:
<br/><br/>
<a href="#ParentTaskLink#">#ParentTaskLink#</a>
<br/><br/>
SubTask List
<br/><br/>
#SubTaskLink#
<br/><br/>
Quick View
<br/><br/>
<a href="#QuickViewLink#">#QuickViewLink#</a>
<br/><br/>
View More...
<br/><br/>
<a href="#ViewMoreLink#">#ViewMoreLink#</a>
<br/><br/>
Thanks!</div>',

'<br /><div><p style="font-size: 13.3333px;">J.M. Grove - Construction &amp; Supply&nbsp;<br /><a href=' + '"http://web.jmgrovebuildingsupply.com/Sr_App/jmgroveconstruction.com"' + '>jmgroveconstruction.com&nbsp;</a><br />
<a href=' + '"http://jmgrovebuildingsupply.com/"' + '>http://jmgrovebuildingsupply.com/</a><br />
<a href=' + '"http://web.jmgrovebuildingsupply.com/login.aspx"' + '>http://web.jmgrovebuildingsupply.com/login.aspx</a><br />
<a href=' + '"http://jmgroverealestate.com/"' + '>http://jmgroverealestate.com/</a><br />
<br />72 E Lancaster Ave<br />Malvern, Pa 19355<br />Human Resources<br />Office:(215) 274-5182 Ext. 4<br />
<a href=' + '"mailto:Hr@jmgroveconstruction.com"' + '>Hr@jmgroveconstruction.com</a></p>
<div style="font-size: 13.3333px;"><a href=' + '"https://www.facebook.com/JMGrove1com/"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/fb.png"' + ' />
</a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/tw.png"' + ' />
</a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/236e0d0b-832c-4543-81a6-f6c460d302f0_zpsl4nh3ane.png.html"' + '>
<img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/gpls.png"' + ' /></a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/pinterest_zpspioq6pve.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/pint.png"' + ' /></a><br />
<a href=' + '"http://s49.photobucket.com/user/jmg1/media/twitter_zpsiiplyhiq.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/hbt.png"' + ' /></a><a href=' + '"http://s49.photobucket.com/user/jmg1/media/youtube_zpsxyhfmm1b.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/yt.png"' + ' /></a>
<a href=' + '"http://s49.photobucket.com/user/jmg1/media/c3894afd-7a37-43e2-917c-5ffb7a5036a2_zpschul0pqd.png.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/houzz.png"' + ' /></a>&nbsp;
<a href=' + '"http://s49.photobucket.com/user/jmg1/media/4478596b-67f4-444e-992a-624af3e56255_zpsoi8p1uyv.jpg.html"' + '><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/linkin.jpg"' + ' /></a></div>
<div style="font-size: 13.3333px;"><img src=' + '"http://web.jmgrovebuildingsupply.com/CustomerDocs/DefaultEmailContents/footer.png"' + ' /></div></div>',
GETDATE(),NULL)

---------------------------------------------------------------------