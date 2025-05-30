use `Hospital_Patients`;
create table hospital_patients(patient_id int primary key, patient_name varchar(100) not null, gender varchar(10), age int, admission_date date,
                 discharge_date date, department varchar(100), diagnosis varchar(100), doctor_name varchar(100), room_type varchar(20));
			
insert into hospital_patients(patient_id, patient_name, gender, age, admission_date, discharge_date, department, diagnosis, doctor_name, room_type)
values 
(1, 'Ravi Kumar', 'Male', 45, '2023-12-01', '2023-12-10', 'Cardiology', 'Hypertension', 'Dr. A. Mehta', 'Private'),
(2, 'Neha Shah', 'Female', 32, '2023-12-05', '2023-12-09', 'Neurology', 'Migraine', 'Dr. R. Deshmukh', 'Semi-Private'),
(3, 'Arjun Verma', 'Male', 28, '2023-12-07', NULL, 'Orthopedics', 'Fracture', 'Dr. K. Joshi', 'General'),
(4, 'Sneha Jain', 'Female', 60, '2023-11-29', '2023-12-06', 'Gastroenterology', 'IBS', 'Dr. P. Roy', 'Private'),
(5, 'Amit Kulkarni', 'Male', 50, '2023-12-02', '2023-12-07', 'Cardiology', 'Angina', 'Dr. A. Mehta', 'Private'),
(6, 'Divya Patil', 'Female', 38, '2023-12-01', NULL, 'Gynecology', 'PCOD', 'Dr. M. Rao', 'Semi-Private'),
(7, 'Vikram Yadav', 'Male', 70, '2023-11-28', '2023-12-05', 'Pulmonology', 'COPD', 'Dr. S. Menon', 'General'),
(8, 'Priya Joshi', 'Female', 25, '2023-12-03', '2023-12-06', 'Dermatology', 'Psoriasis', 'Dr. A. Chatterjee', 'Private'),
(9, 'Karan Reddy', 'Male', 55, '2023-12-04', NULL, 'Urology', 'Kidney Stones', 'Dr. T. Kumar', 'Semi-Private'),
(10, 'Anjali Singh', 'Female', 42, '2023-12-06', '2023-12-10', 'ENT', 'Sinusitis', 'Dr. R. Deshmukh', 'General');


create table patient_treatments(treatment_id int primary key, patient_id int, foreign key(patient_id) references hospital_patients (patient_id),
                     treatment_date datetime, treatment_type varchar(50), treatment_desc varchar(255), doctor_name varchar(300), 
                     cost float not null, medicine_given varchar(100), dosage_mg float, followup_date datetime);
					
                    
insert into patient_treatments values 
(1, 1, '2023-12-02 10:30:00', 'Medication', 'Prescribed antihypertensives', 'Dr. A. Mehta', 1500.00, 'Amlodipine', 5.0, '2023-12-15 09:00:00'),
(2, 1, '2023-12-04 14:00:00', 'Therapy', 'Blood pressure monitoring session', 'Dr. A. Mehta', 800.00, NULL, NULL, '2023-12-20 10:00:00'),
(3, 2, '2023-12-06 09:00:00', 'Medication', 'Migraine pain relief meds', 'Dr. R. Deshmukh', 1200.00, 'Sumatriptan', 50.0, '2023-12-13 09:30:00'),
(4, 3, '2023-12-08 11:15:00', 'Surgery', 'Fracture fixation surgery', 'Dr. K. Joshi', 25000.00, NULL, NULL, '2023-12-22 10:00:00'),
(5, 4, '2023-12-01 10:00:00', 'Medication', 'Prescribed antispasmodics', 'Dr. P. Roy', 900.00, 'Hyoscine', 10.0, '2023-12-10 11:00:00'),
(6, 5, '2023-12-03 15:00:00', 'Medication', 'Chest pain relief meds', 'Dr. A. Mehta', 2000.00, 'Nitroglycerin', 0.4, '2023-12-12 09:30:00'),
(7, 6, '2023-12-02 09:30:00', 'Therapy', 'Hormone balancing therapy', 'Dr. M. Rao', 1500.00, NULL, NULL, '2023-12-17 10:00:00'),
(8, 7, '2023-11-29 13:00:00', 'Medication', 'COPD inhaler treatment', 'Dr. S. Menon', 3000.00, 'Salbutamol', 100.0, '2023-12-14 10:00:00'),
(9, 8, '2023-12-04 10:00:00', 'Medication', 'Topical psoriasis treatment', 'Dr. A. Chatterjee', 1100.00, 'Calcipotriol', 0.05, '2023-12-11 11:00:00'),
(10, 9, '2023-12-05 09:00:00', 'Surgery', 'Kidney stone removal', 'Dr. T. Kumar', 45000.00, NULL, NULL, '2023-12-20 10:00:00');

select * from hospital_patients;
select * from patient_treatments;


# Q1: Show average cost per patient using CTE.

with my_cte as (select patient_id, avg(cost) as "avg_cost"
				from patient_treatments 
                group by patient_id)
select patient_id, avg_cost
from my_cte;


# Q2: Get a list of all distinct doctor names from both tables.

select distinct doctor_name from hospital_patients;
select distinct doctor_name from patient_treatments;


# Q3: Get patient names and their treatments with cost above ₹5000.

select patient_name
from hospital_patients
where  patient_id in (select patient_id from patient_treatments
                     where cost>5000);

# Q4: Delete all treatment records where the cost is 0 or NULL.
delete from patient_treatments
where cost = (0 or null);

# Q5: Add a new column insurance_provider to the hospital_patients table.
alter table hospital_patients
add column insurance_provider varchar(50);

# Q6: Remove the column diagnosis from hospital_patients.
alter table hospital_patients
drop column diagnosis;

select * from hospital_patients;
select * from patient_treatments;


# Q7: Modify doctor_name column to allow only 50 characters.

alter table hospital_patients
modify column doctor_name varchar(50);

# Q8: List all treatments and the names of patients (if the patient exists).
select t.treatment_type, t.treatment_desc, p.patient_name
from patient_treatments as t
right join hospital_patients as p
on t.patient_id =p.patient_id;

# Q9: List all patients with their latest treatment date (if any).
select *
from hospital_patients
left join patient_treatments
on hospital_patients.patient_id = patient_treatments.patient_id;

# Q10: Update room type to 'Semi-Private' for all patients admitted in the Cardiology department and currently admitted (discharge date is NULL).
# Works in PostgreSQL or via UNION of LEFT and RIGHT JOIN.

update hospital_patients
set room_type = "Semi-Private" 
where department = "Cardiology" and discharge_date = null;


# Q11: Show each patient's treatments with previous treatment cost 
select cost,
lag (cost) over (partition by  treatment_type order by cost) as "previous"
from patient_treatments;

select * from hospital_patients;
select * from patient_treatments;

# Q12: Rank treatments per patient by cost
select treatment_id,
rank() over (partition by patient_id order by cost) as "rank"
from patient_treatments;

# Q13: List names and ages of female patients older than 40 who were admitted before December 5, 2023.

select patient_name, age
from hospital_patients
where gender = "Female" and age < 40 and admission_date <"2023-12-05";

# Q: Find the month in which most treatments occurred.
select extract (month from treatment_date) from patient_treatments;

# Q14: Show total cost per patient along with each treatment.

select cost, treatment_type,patient_id,
sum(cost) over (partition by patient_id order by treatment_type) as "total"
from patient_treatments;

# Q: Find departments with more than 2 admitted patients (discharge date is NULL).

select * from hospital_patients;
select * from patient_treatments;

# Q15: List the top 3 most expensive treatments.
select treatment_type, cost
from patient_treatments
order by cost desc
limit 3;

# Q16: Get first and last treatment cost per patient.
select treatment_type, cost,patient_id,
first_value(cost) over (partition by patient_id order by cost) as "first",
last_value(cost) over (partition by patient_id order by cost) as "last"
from patient_treatments;

# Q17: List patients who had a treatment costing more than ₹20,000.

select patient_name, patient_id
from hospital_patients
where patient_id in (select patient_id from patient_treatments
					where cost> 20000);
# Q18: Get all patients who had treatments costing more than ₹7000.

select * from hospital_patients;
select * from patient_treatments;

select patient_name, patient_id
from hospital_patients
where patient_id in (select patient_id from patient_treatments 
                     where cost > 7000);
                     
# Q19: Find the name of the patient who had the earliest registration date.

select patient_name, admission_date
from hospital_patients
order by admission_date asc
limit 1;

# 20. Find treatments that cost more than the average treatment cost.

select * from hospital_patients;
select * from patient_treatments;

select treatment_type, cost
from patient_treatments
where cost >( select avg(cost) from patient_treatments);
                     
# Q21.Get the top 3 patients who spent the highest total cost on treatments, only include patients who had more than 1 treatment and were admitted before 2024-01-01.

select patient_name
from hospital_patients
where patient_id in
(select patient_id, treatment_type, cost,  sum(cost) as "total_cost", count(*)  as "total_treatment" 
from patient_treatments
group by patient_id, treatment_type, cost
having count(*) >1
order by sum(cost) desc
limit 3);

# Q22. List top 5 treatment types (treatment_desc) by average cost, but only include treatments performed more than twice.

select * from hospital_patients;
select * from patient_treatments;

select patient_id, treatment_type, treatment_desc, avg(cost) as "avg_cost", count(*) as "treatments performed"
from patient_treatments
group by patient_id,treatment_type, treatment_desc
having count(*)>2
order by avg(cost) desc
limit 5;