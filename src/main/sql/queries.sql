/*d*/
insert into region(r_name)
    VALUES('Amadora')
;

insert into player(email,username,activity_state,region_name)
VALUES('jose@gmail.com','jose','Active','Amadora')
;

update player
set activity_state='Inactive'
where username='jose';

update player
set activity_state='Banned'
where email='jose@gmail.com';

/*e*/

