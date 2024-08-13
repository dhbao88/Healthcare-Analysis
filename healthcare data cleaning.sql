use health;
rename table healthcare_dataset to healthcare;
select * from healthcare;
set sql_safe_updates=0;
drop function if exists proper;
delimiter $$
create function proper(input text) returns varchar(30)
deterministic
begin
	declare i int default 1;
    declare len int default length(input);
    declare c varchar(1) default '';
    declare result varchar(30) default '';
    declare reset boolean default true;
    
    while i<= len do
		set c=substring(input,i,1);
        if reset then 
			set result=concat(result,upper(c));
            set reset = false;
		elseif reset =false and c=' ' then
			set result=concat(result,' ');
            set reset= True;
		else 	
			set result= concat(result,lower(c));
		end if;
		set i=i+1;
    end while ;
    return result;
end $$

delimiter ;

select proper('hello world');

update healthcare
set Name= proper(Name);

select  * from healthcare;

drop function if exists cleantext;
delimiter $$
create function cleantext(input text) returns varchar(36)
deterministic
begin 
	if input like "%and%" then
		if input like "and,%" then 
			set input =replace(input,'and,','');
		elseif input like "and ,%" then 
			set input =replace(input,'and ,','');
		elseif input like "%,and" then 
			set input =replace(input,',and','');
		elseif input like "%, and" then 
			set input =replace(input,', and','');
		elseif input like "and%" then 
			set input =replace(input,'and','');
		elseif input like "%and" then 
			set input =replace(input,'and','');
		end if;
	end if;
    
    if input like "%,%" then
		set input =replace(input,',','');
	end if;
    return input;
end $$
delimiter ;

alter table healthcare
add column Hospital_cleaned varchar(36)
after hospital;

update healthcare
set hospital_cleaned=hospital;

update healthcare
set hospital_cleaned=cleantext(hospital);

select * from healthcare;

alter table healthcare 
drop column hospital_coppied;

update healthcare
set `Billing Amount`=round(`Billing Amount`,0);

update healthcare
set `Date of Admission`=str_to_date(`Date of Admission`,"%Y-%m-%d");

alter table healthcare
modify column `Date of Admission` Date;

update healthcare
set `Discharge Date`=str_to_date(`Discharge Date`,"%Y-%m-%d");

alter table healthcare
modify column `Discharge Date` Date;

select * from healthcare;

alter table healthcare
add column age_range varchar(10) after age;
update healthcare 
set age_range =case
	when age >0 and age <=17 then " Under 18"
	when age >=18 and age <=24 then "18 - 24"
    when age >=25 and age <=34 then "25 - 34"
    when age >=35 and age <=44 then "35 - 44"
    when age >=45 and age <=54 then "45 - 54"
    when age >=55 and age <=64 then "55 - 64"
    else "65+"
end ;

