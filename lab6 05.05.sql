use s1231
go

--1 sprawdz swoje uprawnienia na serwerze SQL
select * from sys.fn_my_permissions(default,'SERVER')

--2 sprawdz swoje uprawnienia w bazie danych SQL
select * from sys.fn_my_permissions(default,'DATABASE')

--3 utworz tabele o nazwie Towar, zawierajaca 4 kolumny:
--identyfikator, liczba, autoinkrementacja, klucz glowny
--nazwa towaru, tekst, 20 znakow
--cena, waluta
--data dodania, data

create table Towar --create table s1231.dbo.Towar
(
id int identity (1,1) primary key,
nazwa varchar(20),
cena money,
data_dodania date default getdate()
)

--4 wykorzystujac autoinkrementacje dodac do tablicy Towar 3 wiersze:
--olowek 1,29 zl
--kredka 0,52 zl
--dlugopis 1,32 zl 

insert into Towar (nazwa, cena) values
('olowek',1.29),
('kredka',0.52),
('dlugopis',1.32)

--5 zmienic uprawnienia na tabeli usuwajac innemu uzytkownikowi mozliwosc
--przegladania zawartosci tabeli
use master
go
create login s1231 with password='student'
go
create user s1231 for login s1231
go
exec sp_addrolemember @membername='s1231', @rolename='db_datareader'
go
deny select on Towar to s1231
--uzytkownicy sa przypisani do bazy a loginy do serwera
--login po to zeby sie zalogowac do serwera
--uzytkownik zeby wejsc do bazy
--na koniec rola odczytu danych


--6 sprawdzic swoje uprawnienia na obiekcie innego uzytkownika
exec sp_helprotect null, 's1231'
--7
revoke select on Towar to s1231

--8
use master
deny insert, alter, update on Towar to s1231

select * from Towar

--9
grant insert on Towar to s1231
exec sp_helprotect null,'s1231'

--10 
deny all on Towar to s1231
--all nie powinno byc uzywane, bo nie blokuje wszystkich

--11 
select DATEADD(dd, 100, getdate())

--12
select id,nazwa,cena,
DATENAME(DW,data_dodania) as 'dzien tygodnia' from Towar 

--13
select id, nazwa, cena, 
DATENAME(dw,data_dodania) as 'dzien dodania',
DATENAME(mm,data_dodania) as 'miesiac dodania',
DATENAME(YEAR,data_dodania) as 'rok dodania' -- year(data_dodania) as rok
from Towar

--14
select datediff(dd,getdate(), '2020-10-01')

--15 
insert into Towar (nazwa,cena) values
('mazak czerwony', null),
('mazak zielony', null)

--jest duzo bledow przez nulle, czasem trzeba to zamienic na zero
--16
select nazwa, data_dodania, isnull(cena,9.99) as 'cena'
 from Towar

 --17
 create type t_czas as table (id int, nazwa varchar(20))

 create table t1 (id int, b t_czas)
 --18
 --definiowanie typu tablicowego
 go
 create procedure WyswietlTowary
 as
 begin
	declare @tc t_czas
	insert into @tc values (1,'styczen'),(3,'marzec'),(5,'maj')
	--select * from @tc
	declare @miesiac varchar(20), @towar varchar(30), @licznik int
	set @licznik=1
	while @licznik<5
	begin
		select @towar =t.nazwa, @miesiac=c.nazwa from towar t, @tc c 
		where c.id=month(data_dodania) and t.id=@licznik
		print @towar +space(1) +@miesiac
		set @licznik+=1
	end
 end
 exec WyswietlTowary

 --19
 deny execute on WyswietlTowary to s1231
 exec sp_helprotect null, 's1231'

 --20
 create role rola_towar
 go

 grant all on towar to rola_towar
 go
 sp_helprole
 sp_helprotect

 --21
 grant execute on WyswietlTowary to rola_towar
 sp_helprotect

 --22
 exec sp_addrolemember @rolename='rola_towar', @membername='s1231'
 exec sp_helprolemember
