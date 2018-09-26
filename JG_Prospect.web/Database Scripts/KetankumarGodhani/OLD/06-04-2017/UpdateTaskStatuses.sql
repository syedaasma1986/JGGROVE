
update tbltask 
SET 
	AdminStatus=0
WHERE 
AdminStatus is null and tasklevel in (1,2)


update tbltask 
SET 
	techleadstatus=0
WHERE 
TechLeadStatus is null and tasklevel in (1,2)


update tbltask 
SET 
	otheruserstatus = 0
WHERE 
otheruserstatus is null and tasklevel in (1,2)

