create database railway_maintenance;
use railway_maintenance;
show tables;

-- table creation 


create table railway_zone (
    zone_id int primary key,
    zone_name varchar(100) not null
);

create table railway_station (
    station_id int primary key,
    station_name varchar(100) not null,
    city varchar(50),
    zone_id int,
    foreign key (zone_id) references railway_zone(zone_id)
);

create table railway_track (
    track_id int primary key,
    track_name varchar(100) not null,
    source_station int,
    destination_station int,
    track_length decimal(8,2),
    status varchar(30) default 'active',
    foreign key (source_station) references railway_station(station_id),
    foreign key (destination_station) references railway_station(station_id)
);

create table track_section (
    section_id int primary key,
    track_id int,
    section_name varchar(100),
    start_km decimal(8,2),
    end_km decimal(8,2),
    condition_status varchar(30),
    foreign key (track_id) references railway_track(track_id)
);

create table train (
    train_id int primary key,
    train_number varchar(20) unique,
    train_name varchar(100),
    train_type varchar(50)
);

create table sensor_type (
    sensor_type_id int primary key,
    sensor_name varchar(50),
    measurement_unit varchar(20)
);

create table sensor (
    sensor_id int primary key,
    section_id int,
    sensor_type_id int,
    installation_date date,
    sensor_status varchar(30) default 'active',
    foreign key (section_id) references track_section(section_id),
    foreign key (sensor_type_id) references sensor_type(sensor_type_id)
);

create table sensor_reading (
    reading_id int primary key auto_increment,
    sensor_id int,
    reading_value decimal(10,2),
    reading_time datetime default current_timestamp,
    foreign key (sensor_id) references sensor(sensor_id)
);

create table fault_type (
    fault_type_id int primary key,
    fault_name varchar(100),
    severity varchar(30)
);

create table fault (
    fault_id int primary key auto_increment,
    section_id int,
    fault_type_id int,
    reading_id int,
    fault_date datetime default current_timestamp,
    priority varchar(30),
    description varchar(255),
    status varchar(30) default 'open',
    foreign key (section_id) references track_section(section_id),
    foreign key (fault_type_id) references fault_type(fault_type_id),
    foreign key (reading_id) references sensor_reading(reading_id)
);

create table technician (
    technician_id int primary key,
    technician_name varchar(100),
    phone varchar(15),
    specialization varchar(100)
);

create table maintenance_request (
    request_id int primary key auto_increment,
    fault_id int,
    request_date datetime default current_timestamp,
    priority varchar(30),
    status varchar(30) default 'pending',
    foreign key (fault_id) references fault(fault_id)
);

create table technician_assignment (
    assignment_id int primary key auto_increment,
    request_id int,
    technician_id int,
    assigned_date datetime default current_timestamp,
    foreign key (request_id) references maintenance_request(request_id),
    foreign key (technician_id) references technician(technician_id)
);

create table maintenance_activity (
    activity_id int primary key auto_increment,
    request_id int,
    activity_date date,
    activity_description varchar(255),
    status varchar(30),
    cost decimal(10,2),
    foreign key (request_id) references maintenance_request(request_id)
);

create table spare_part (
    part_id int primary key,
    part_name varchar(100),
    quantity int,
    unit_price decimal(10,2)
);

create table maintenance_parts (
    activity_id int,
    part_id int,
    quantity_used int,
    primary key (activity_id, part_id),
    foreign key (activity_id) references maintenance_activity(activity_id),
    foreign key (part_id) references spare_part(part_id)
);

create table inspection (
    inspection_id int primary key auto_increment,
    section_id int,
    technician_id int,
    inspection_date date,
    condition_status varchar(30),
    remarks varchar(255),
    foreign key (section_id) references track_section(section_id),
    foreign key (technician_id) references technician(technician_id)
);

create table alert (
    alert_id int primary key auto_increment,
    sensor_id int,
    alert_type varchar(100),
    alert_message varchar(255),
    alert_time datetime default current_timestamp,
    status varchar(30) default 'new',
    foreign key (sensor_id) references sensor(sensor_id)
);

create table audit_log (
    log_id int primary key auto_increment,
    action varchar(100),
    table_name varchar(100),
    action_time datetime default current_timestamp,
    description varchar(255)
);

-- insert value 


insert into railway_zone values
(1, 'southern railway'),
(2, 'central railway');

insert into railway_station values
(101, 'chennai central', 'chennai', 1),
(102, 'trichy junction', 'trichy', 1),
(103, 'madurai junction', 'madurai', 1),
(104, 'coimbatore junction', 'coimbatore', 1);

insert into railway_track values
(201, 'chennai-trichy main line', 101, 102, 320.50, 'active'),
(202, 'trichy-madurai main line', 102, 103, 140.20, 'active'),
(203, 'trichy-coimbatore line', 102, 104, 210.40, 'active');

insert into track_section values
(301, 201, 'section a', 0.00, 50.00, 'good'),
(302, 201, 'section b', 50.00, 100.00, 'normal'),
(303, 202, 'section c', 0.00, 60.00, 'poor'),
(304, 203, 'section d', 20.00, 80.00, 'normal');

insert into train values
(401, '12601', 'chennai express', 'express'),
(402, '12637', 'pandian express', 'express'),
(403, '12674', 'cheran express', 'express');

insert into sensor_type values
(1, 'vibration', 'mm/s'),
(2, 'temperature', 'celsius'),
(3, 'pressure', 'bar');

insert into sensor values
(501, 301, 1, '2025-01-10', 'active'),
(502, 302, 1, '2025-02-15', 'active'),
(503, 303, 2, '2025-03-20', 'active'),
(504, 304, 3, '2025-04-05', 'active');

insert into sensor_reading
(sensor_id, reading_value, reading_time)
values
(501, 3.50, '2026-09-28 10:00:00'),
(501, 4.20, '2026-09-28 11:00:00'),
(502, 8.50, '2026-09-28 12:00:00'),
(503, 75.00, '2026-09-28 13:00:00'),
(504, 5.20, '2026-09-28 14:00:00');

insert into fault_type values
(1, 'high vibration', 'high'),
(2, 'high temperature', 'critical'),
(3, 'high pressure', 'medium');

insert into technician values
(601, 'ravi', '9876543210', 'track maintenance'),
(602, 'kumar', '9876543211', 'sensor maintenance'),
(603, 'arun', '9876543212', 'railway inspection');

insert into spare_part values
(701, 'rail clip', 500, 150.00),
(702, 'sensor unit', 50, 2500.00),
(703, 'track bolt', 1000, 80.00);

-- Queries
-- View all tracks
select * from railway_track;

-- view all sensors
select * from sensor; 

-- View sensor readings
 select * from sensor_reading; 

-- Track + section details:
select t.track_name,

    s.section_name,

    s.start_km,

    s.end_km,

    s.condition_status

from railway_track t

join track_section s

on t.track_id = s.track_id; 

-- Sensor + reading detail: 
select 
    s.sensor_id,

    st.sensor_name,

    sr.reading_value,

    st.measurement_unit,

    sr.reading_time

from sensor s

join sensor_type st

on s.sensor_type_id = st.sensor_type_id

join sensor_reading sr

on s.sensor_id = sr.sensor_id;

-- Find High Vibration:
select
    sensor_id,
    reading_value,
    reading_time
from sensor_reading
where reading_value > 7;

-- Find Poor Track Sections
select *
from track_section
where condition_status = 'poor';

-- Create Fault
insert into fault
(section_id, fault_type_id, reading_id, priority, description)
values
(302, 1, 3, 'high', 'abnormal vibration detected');


-- Check:

select * from fault;

-- Maintenance Request:
insert into maintenance_request
(fault_id, priority, status)
values
(1, 'high', 'pending');

-- Assign Technician:

insert into technician_assignment
(request_id, technician_id)
values
(1, 601);


-- Maintenance Activity:

insert into maintenance_activity
(request_id, activity_date, activity_description, status, cost)
values
(1, '2026-09-29', 'track inspection and rail clip replacement',
'completed', 5000);

