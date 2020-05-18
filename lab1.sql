use [s12-31]
go

--wprowadzenie 
create table t(id int, k1 varchar(10))
insert into t values
(1,'styczen'),
(2,'luty')

select * from t

--zmiana nazwy kolumny w tableli
sp_rename 't.k1','k2','column';

--zmiana nazwy tabeli
sp_rename 't','tab'

select * from tab

--tworzenie kopii tabeli
select * into kopia from tab

select * from kopia

--zmiana typu danych kolumny
alter table kopia alter column k2 char(100)

--dodawanie nowej kolumny do tabeli
alter table kopia add k3 numeric(2)

--usuwanie kolumny
alter table kopia drop column k2

--dodawanie indeksu do kolumny 
create index t_index on tab(k2)

--usuwanie indeksu
drop index t_index on tab

--usuwanie tabel
drop table tab
drop table kopia


--zad1 utworz tabele pracownicy
create table Pracownicy
(id_pracownika numeric(2) identity(1,1) primary key,
imie varchar(20),
nazwisko varchar(20),
wiek numeric(3),
dzial char(3))

insert into Pracownicy values
('Jan','Nowak',27,'INF'),
('Adam','Kowalski',26,'MAN'),
('Anna','Nowak',24,'MGT'),
('Ewa','Kowalska',23,'ACC')

select * from Pracownicy

--zad2 na podst tabeli Pracownicy stworzyc kopie Uzytkownicy
select id_pracownika as id_uzytkownika, imie, nazwisko, wiek
into Uzytkownicy
from Pracownicy

select * from Uzytkownicy

--zad3 kopia pracownicy - studenci <25 lat
select id_pracownika as id_studenta, imie, nazwisko, wiek, dzial 
into Student
from Pracownicy
where wiek < 25

select * from Student

--zad4 
delete from Uzytkownicy where wiek <25 and nazwisko like 'K%'

select * from Uzytkownicy

--zad5
drop table Uzytkownicy
drop table Student

--zad6 
create table Region
(id_regionu numeric(2) primary key,
nazwa varchar(20),
id_pracownika numeric(2) foreign key (id_pracownika)
references Pracownicy(id_pracownika))

insert into Region values
(1,'pomorskie',4),
(2,'zachodniopomorskie',2),
(3,'warminsko-mazurskie',3)

select * from Region
--weryfikacja
select * from Pracownicy p, Region r
where p.id_pracownika=r.id_pracownika

--zad7 
create table Osoba
(id numeric(2) primary key,
imie varchar(20),
nazwisko varchar(20),
pesel varchar(11) unique,
data_urodzenia date)

insert into Osoba values
(1,'Jan','Kowalski','65121812434','1965-12-18'),
(2,'Adam','Nowak','54052314588','1954-05-23'),
(3,'Ewa','Zielinska','88111238273','1988-11-12'),
(4,'Anna','Wozniak','92012013728','1992-01-20');

select * from Osoba

--zad8
sp_rename 'Osoba' ,'Pracownik'
select * from Pracownik

--zad9
alter table Pracownik add dzial varchar(20), wyksztalcenie varchar(20)

select * from Pracownik
--zad10
update Pracownik set dzial ='organizacyjny'
update Pracownik set wyksztalcenie='wyzsze' where id<3

select * from Pracownik

--10
select * into pracownik_kopia from Pracownik

-- unique nie przenosi sie do kopiowanej tabeli
--11
alter table pracownik_kopia drop column pesel

--12 
alter table pracownik_kopia alter column nazwisko varchar(40)

--13
sp_rename 'pracownik_kopia.id','id_pracownika','column'

--14
create index pracownik_imie_nazwisko on Pracownik(imie,nazwisko)

select * from Pracownik where nazwisko like '%ska'

--15
drop index pracownik_imie_nazwisko on  Pracownik

