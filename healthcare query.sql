select * from healthcare;

#patients by age_range
select age_range, count(*) from healthcare 
group by 1 
order by 1 asc;

#patients sex distribution;
select gender, count(*) from healthcare
group by 1
order by 2;


#patients by blood type;
select `Blood Type`, count(*) from healthcare
group by 1
order by 2 desc;

#patients by Medical Condition
select `Medical Condition`, count(*) from healthcare
group by 1
order by 2 desc;

#Patient in and patient out over month/year
with Patient_Discharge as( 
select date_format(`Discharge Date`, "%Y-%m") as Date_D,  
count(*) as patients
from healthcare
group by 1
order by 1 asc),
Patient_Admission as( 
select date_format(`Date of Admission`,"%Y-%m") as Date_A,  
count(*) as patients 
from healthcare
group by 1
order by 1 asc)
select 
pa.Date_A,
pa.patients as patients_in,
pd.patients as patients_out
from patient_admission as pa
inner join patient_discharge as pd
on pa.Date_A=pd.Date_D
order by 1; 

#patients by hospital
select hospital, count(name) 
from healthcare
group by 1 
order by 2 desc;

#total revenue
select sum(`Billing Amount`) as total_revenue 
from healthcare;