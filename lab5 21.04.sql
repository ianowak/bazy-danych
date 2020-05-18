use s1231
go

--1
create table osoba(id numeric(6) primary key identity(100000,10),
imie varchar(30),
nazwisko varchar(50),
wiek numeric(3,0),
data_dodania date default getdate());

--2
insert into osoba(imie,nazwisko,wiek)
values
('Jan','Kowalski',35),
('Anna','Nowak',30),
('Ewa','Zieliñska',38),
('Adam','WoŸniak',31);


select * from osoba

--wprowadzenie do wyzwalaczy
create table t(id int)
GO

create trigger t1 
on t 
for insert
as
begin
	declare @liczba as integer
	select @liczba=id from t
	print ' wstawiono liczbe ' + cast(@liczba as varchar(10))
end
go

insert into t values (10)
go

create trigger t2 on t
for insert --wczesniej bylo before, jest wykonywany wczesniej niz after
as
begin
	print 'trigger t2'
end
go

insert into t values (20)
go

create trigger t3 on t
after insert, update, delete --after, jest dalej niz for ale jest wykonywany przed zakonczeniem transakcji
as
begin
	print 'trigger t3'
end
go

insert into t values (30)
go

--3 

create trigger DodanoOsobe on osoba
for insert
as
begin
	print 'wiersz zostal dodany'
end
go

insert into osoba (imie,nazwisko,wiek) values ('Adam','Adamski',20)
go
--3a
create trigger WiekOsoby
on osoba
for insert
as
begin
	declare @wiek as integer
	select @wiek=wiek from osoba
	print 'dodano osobe w wieku' + cast(@wiek as varchar(10))
end
go

insert into osoba (imie,nazwisko,wiek) values ('Ewa','Adamska',21)

--4
--delete tylko do usuwania wierszy, drop do procedur itp
drop trigger DodanoOsobe
drop trigger WiekOsoby
go
--5
create trigger ModyfikujOsobe
on osoba
for insert, update, delete
as
begin
	rollback transaction --wycofuje transakcje, wykonuje sie zanim sie zakonczy, transakcja zostaje przerwana
	raiserror('osoby nie mozna modyfikowac',1,1)--pierwszy nr to surowosc bledu, im wiekszy tym powazniejszy, nastepny nr to nr bledu
end
go
--level 16 bledu ma kolor czerwony, nizsze czarny
insert into osoba(imie, nazwisko,wiek) values ('Adam','Nowacki',22)
select * from osoba

--6
drop trigger modyfikujosobe
go
--7 

create trigger DodanoOsoby
on osoba
for insert
as
declare @imie as varchar(20), --zmienne przed beginem sa globalne, a za beginem lokalne
@nazwisko as varchar(20)
begin
	
	select @imie=imie from osoba
	select @nazwisko=nazwisko from osoba
	print @imie +' ' + @nazwisko
end
go

insert into osoba (imie,nazwisko,wiek) values ('Adam','Nowacki',22)
--8 
drop trigger DodanoOsoby
go
--9 Utworzyæ wyzwalacz o nazwie SprawdzWiek,
-- który zablokuje mo¿liwoœæ wprowadzenia osoby w wieku 
--innymi ni¿ w przedziale 0-120 lat.

create trigger SprawdzWiek
on osoba
for insert, update -- update wykonuje sie jako pierwszy
as
begin
	declare @wiek as integer
	select @wiek=wiek from osoba
	if @wiek not between 0 and 120
	begin
		rollback transaction
		raiserror ('zly wiek',1,1)
	end
end
go

--10
insert into osoba (imie,nazwisko,wiek) values ('Anna','Nowacka',132)
select * from osoba

--11
drop trigger SprawdzWiek

--12 
update osoba
set wiek+=90

select * from osoba

--13
update osoba set wiek-=90

update osoba set wiek+=90
where wiek+90 <=120
select * from osoba
go

--14
create trigger DodajDane
on osoba
for insert
as
begin
	declare @wiek as int, @zapytanie as varchar(100)
	select @wiek=wiek from osoba
	set @zapytanie='select * from osoba where wiek = ' +cast(@wiek as varchar(3))
	exec(@zapytanie)
end
go

--to samo tylko inaczej
--create trigger DodajDane
--on osoba
--for insert
--as
--begin
	--declare @wiek as int, @zapytanie as varchar(100)
	--select @wiek=wiek from osoba
	--select * from osoba where wiek = @wiek
--end
--go

insert into osoba (imie,nazwisko,wiek) values ('Jan','Nowacki',31)

drop trigger DodajDane
go
--15
create trigger wyswietl
on osoba
after insert, update, delete
as 
begin
	select * from osoba
end
go
insert into osoba (imie,nazwisko,wiek) values ('Ewa','Kowalska',33)
update osoba set wiek+=1
delete osoba where imie='Ewa' and nazwisko='Kowalska'

drop trigger wyswietl

--16
create table grupa (numer varchar(10), id numeric(6))

insert into grupa values ('s1231', 100010)

create trigger wyswietl
on grupa
for insert
as
begin
	declare @id as numeric(6), @numer as varchar(10),
	@imie varchar(20), @nazwisko varchar(30)
	select @id=id from grupa
	select @numer=numer from grupa
	select @imie=imie, @nazwisko=nazwisko from osoba where id=@id
	print 'dodano uzytkownika ' +cast(@id as varchar(6)) + space(1) +@imie
	+space(1) +@nazwisko+ ' do grupy ' +@numer

end
go

insert into grupa values ('S1231',100010)
go