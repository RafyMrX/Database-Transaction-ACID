create database database_acid;

show databases;

use database_acid;
show tables;

create table accounts(
    id varchar(100) primary key,
    name varchar(100) not null,
    balance bigint not null
)engine = innoDB;
desc accounts;
select * from accounts;
delete from accounts;

# ATOMICITY
# menjadikan banyak transaksi menjadi satu kesatuan, jika teransaksi behasil maka semu juga berhasil begitupun sebaliknya jika gagal
start transaction;
insert into accounts(id, name, balance) values('dinda', 'Adinda', 200000);
insert into accounts(id, name, balance) values('suma', 'Kusuma', 1000000);
commit;
rollback ;

# CONSISTENCY
# consistency data dengan constrain pada level database
# setiap data yang ditulis pada database hasrus valid sesuai dengan aturan yang telah dintentukan pada constrain atau pada level aplikasi
alter table accounts
add constraint check_balance check ( balance >= 50000 );

alter table accounts
drop constraint check_balance;

show create table accounts;

# ISOLATION
# meninimalisir terjadinya race condition ketika data yang sama diakses pada waktu yang sama.
# user yang ke 2 akan diberikan akses data ketika user 1 sudah commit atau sudah selesai transakasi
start transaction;

select * from accounts where id in ('rafy', 'teler') for update;
update accounts set balance = balance - 500000 where id = 'teler';
update accounts set balance = balance + 500000 where id = 'rafy';

commit;

# durability
# menjamin data bahwa jika suatu proses transaksi gagal di tengah perjalanan makan akan kembali ke awal sehingga data akan seperti semula dan tidak rusak
# transaksi akan berhasil atau data akan disimpan ketika sudah commit
start transaction;

select * from accounts where id in ('rafy', 'teler') for update;

update accounts set balance = balance - 500000 where id = 'rafy';
# MYSQL SHUTDOWN
update accounts set balance = balance + 500000 where id = 'teler';

commit;

