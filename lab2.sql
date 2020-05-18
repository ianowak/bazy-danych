--wprowadzenie podzapytania, zapytania zew i wew

create table w
(id int primary key,
liczba numeric(4),
nazwa varchar(20))

insert into w values
(1,10,'A'),
(2,12,'B'),
(3,43,'C'),
(4,54,'D'),
(5,22,'E'),
(6,75,'F'),
(7,98,'G')

select * from w

with zapytanie as(
select case
when liczba<15 then 'mniej niz 15'
when liczba between 15 and 30 then '15-30'
else 'powyzej 30'
end as kategoria, nazwa, liczba 
from w)
select kategoria, SUM(liczba) as suma, COUNT(*) as liczba_wystapien
from zapytanie group by kategoria --trzeba zrobic group zeby sum zadzialalo

--dodawanie klucza glownego do istniejacej tablei
create table n (id int, nazwa varchar(20))

--zmienic kolumne na not null
alter table n alter column id int not null

--dodajemy klucz
alter table n add primary key(id)

--importujemy z excela 
--zad1 i 2

alter table GrupaProduktu
alter column [id grupy produktu] int not null
go
alter table GrupaProduktu add primary key ([id grupy produktu])

alter table JednostkaMiary
alter column [id jednostki miary] int not null
go
alter table JednostkaMiary add primary key ([id jednostki miary])

--zad3
create table Produkt(
idProduktu numeric(3) primary key,
nazwaProduktu varchar(20),
[id grupy produktu] int foreign key ([id grupy produktu])
references GrupaProduktu ([id grupy produktu]),
[id jednostki miary] int foreign key ([id jednostki miary])
references JednostkaMiary ([id jednostki miary]))

insert into Produkt values
(1, 'chleb',1,1),
(2,'bulka',1,1),
(3,'sok pomidorowy',2,3),
(4,'sok pomaranczowy',2,3),
(5,'sok jablkowy',2,3)

select * from Produkt

--zad4 
create table Sklep(
idSklepu numeric(4) primary key,
nazwaSklepu varchar(20),
wojewodztwo varchar(30))

insert into Sklep values
(1,'A','pomorskie'),
(2,'B','pomorskie'),
(3,'C','zachodniopomorskie'),
(4,'D','zachodniopomorskie')

select * from Sklep


create table sprzedaz
(idSprzedazy int primary key identity(1,1),
idProduktu numeric(3) foreign key (idProduktu)
references Produkt(idProduktu),
idSklepu numeric(4) foreign key (idSklepu)
references Sklep(idSklepu),
datatransakcji datetime2,
ilosc numeric(5,1),
cena money)

insert into sprzedaz values
(1,1,getdate(),5,7),
(1,1,getdate(),5,8),
(1,1,getdate(),15,20),
(1,1,getdate(),20,22),
(2,1,getdate(),1,2),
(2,1,getdate(),3,8),
(2,1,getdate(),2,4.5),
(2,1,getdate(),3,12),
(1,1,getdate(),5,7),
(1,1,getdate(),5,8),
(1,1,getdate(),15,20),
(1,1,getdate(),20,22),
(3,1,getdate(),1,3),
(3,1,getdate(),3,9),
(3,1,getdate(),2,4.5),
(3,1,getdate(),3,12),
(4,1,getdate(),2,3),
(4,1,getdate(),3,6),
(4,1,getdate(),2,4),
(4,1,getdate(),3,12),
(5,1,getdate(),1,2),
(5,1,getdate(),2,8),
(5,1,getdate(),2,4.5),
(5,1,getdate(),3,12);


insert into sprzedaz values
(1,2,getdate(),5,8),
(1,2,getdate(),5,9),
(1,2,getdate(),15,21),
(1,2,getdate(),20,23),
(2,2,getdate(),1,3),
(2,2,getdate(),3,9),
(2,2,getdate(),2,5.5),
(2,2,getdate(),3,13);



select * from sprzedaz