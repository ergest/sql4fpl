update player_understat_2021
set team_title = 'Leeds'
where team_title like '%Leeds%';

update player_understat_2021
set team_title = 'Man Utd'
where team_title like 'Man%United%';

update player_understat_2021
set team_title = 'Man City'
where team_title like 'Man%City%';

update player_understat_2021
set team_title = 'Newcastle'
where team_title like '%Newcastle%';

update player_understat_2021
set team_title = 'Wolves'
where team_title like '%Wolv%';

update player_understat_2021
set team_title = 'Spurs'
where team_title like '%Tottenham%';

update
	player_understat_2021 pu
set 
	fpl_id = p.id
from 
	player_2021 p
	join teams_2021 t on p.team = t.id 
where
	pu.player_name = 'Rodri'
	and p.web_name = 'Rodrigo'
	and t."name" = 'Man City'
	and pu.fpl_id = 0;

update
	player_understat_2021 pu
set 
	fpl_id = p.id
from 
	player_2021 p
	join teams_2021 t on p.team = t.id 
where
	pu.player_name = 'Tanguy NDombele Alvaro'
	and p.web_name = 'Ndombele'
	and t."name" = 'Spurs'
	and pu.fpl_id = 0;

update
	player_understat_2021 pu
set 
	fpl_id = p.id
from 
	player_2021 p
	join teams_2021 t on p.team = t.id 
where
	1=1
	and pu.team_title = t."name" 
	and pu.player_name = p.first_name || ' ' || p.second_name 
	and not exists (select * from player_understat_2021 where fpl_id = p.id)
	and pu.fpl_id = 0;

update
	player_understat_2021 pu
set 
	fpl_id = p.id
from 
	player_2021 p
	join teams_2021 t on p.team = t.id 
where
	1=1
	and pu.team_title = t."name"
	and split_part(pu.player_name, ' ', 1) = split_part(p.first_name, ' ', 1)
	and split_part(pu.player_name, ' ', 2) = split_part(p.second_name, ' ', 1)
	and not exists (select * from player_understat_2021 where fpl_id = p.id)
	and pu.fpl_id = 0;

update
	player_understat_2021 pu
set 
	fpl_id = p.id
from 
	player_2021 p
	join teams_2021 t on p.team = t.id 
where
	1=1
	and pu.team_title = t."name"
	and split_part(pu.player_name, ' ', 1) = split_part(p.first_name, ' ', 1)
	and not exists (select * from player_understat_2021 where fpl_id = p.id)
	and pu.fpl_id = 0;

update
	player_understat_2021 pu
set 
	fpl_id = p.id
from 
	player_2021 p
	join teams_2021 t on p.team = t.id 
where
	1=1
	and pu.team_title = t."name"
	and split_part(pu.player_name, ' ', 2) = split_part(p.second_name , ' ', 1)
	and not exists (select * from player_understat_2021 where fpl_id = p.id)
	and pu.fpl_id = 0;

update
	player_understat_2021 pu
set 
	fpl_id = p.id
from 
	player_2021 p
	join teams_2021 t on p.team = t.id 
where
	1=1
	and pu.team_title = t."name" 
	and split_part(pu.player_name, ' ', 1) = p.web_name
	and not exists (select * from player_understat_2021 where fpl_id = p.id)
	and pu.fpl_id = 0;

update
	player_understat_2021 pu
set 
	fpl_id = p.id
from 
	player_2021 p
	join teams_2021 t on p.team = t.id 
where
	1=1
	and pu.team_title = t."name" 
	and split_part(pu.player_name, ' ', 2) = p.web_name
	and not exists (select * from player_understat_2021 where fpl_id = p.id)
	and pu.fpl_id = 0;

update
	player_understat_2021 pu
set 
	fpl_id = p.id
from 
	player_2021 p
	join teams_2021 t on p.team = t.id 
where
	1=1
	and pu.team_title = t."name" 
	and pu.player_name = p.web_name
	and not exists (select * from player_understat_2021 where fpl_id = p.id)
	and pu.fpl_id = 0;