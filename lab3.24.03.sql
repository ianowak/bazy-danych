use s1231
go

--deklaracja zmiennych
declare
@liczba numeric(5),
@tekst varchar(20)
begin
	set @liczba=10 --tu nie mozna
	select @tekst='ABC'--, @liczba=10
	print @tekst + ' ' + cast(@liczba as varchar(5)) --w starszej dokumentacji convert zamiast cast
end
go

--instrukcja warunkowa 
declare
@liczba as numeric(5) --moze byc bez as
begin 
	set @liczba=100
	if @liczba<100
	begin
		print 'mniej niz 100'
	end
	else if @liczba<200 print 'mniej niz 200' --nie trzeba begin jesli jest 1 instrukcja warunkowa
	else print '200 i wiecej'
end
go

--petle
begin
	declare @i as numeric(5)
	select @i=1
	while @i<10
	begin
		print @i
		select @i+=1 -- rownowazne set @i=@i+1
	end
end
go

--wykonywanie skladni sql w bloku anonimowym
create table Produkt
(idproduktu int identity(1,1) primary key,
nazwaproduktu varchar(20))
insert into Produkt values
('chleb'),
('maslo')
select * from Produkt


begin
	declare @zapytanie as varchar(200)
	set @zapytanie='select count(*) as liczba_wystapien from Produkt'
	exec(@zapytanie)
end
go

--1
declare 
@imie varchar(20),
@nazwisko varchar(30),
@numer_porzadkowy numeric(10)
begin
	select @imie='Jan',@nazwisko='Kowalski',@numer_porzadkowy=100
	print @imie + ' ' + @nazwisko + ' ' + cast(@numer_porzadkowy as varchar(5))
end
go
	
--2
declare
@zapytanie as varchar(200)
begin
	set @zapytanie='select count(*) as liczbawierszy into Raport3 from Produkt'
	exec(@zapytanie)
end
go

select * from Raport3

--3
begin
	declare @i as numeric(2)
	set @i=1 --@i=2
	while @i<=10
	begin
		if @i%2 = 0 print @i
		set @i+=1 --@i+=2
	end
end

waitfor delay '00:00:02'
go

--4
begin
	declare @i as numeric(2)
	select @i =1
	while @i<10
	begin
		select @i+=1
		if @i%3 = 0 print 'liczba ' +cast(@i as varchar(2)) + ' podzielna przez 3'
		else print @i
	end
end
go

--5
declare 
@tworzenietabeli varchar(100), --zapytanie tworzace tabele
@wstawianiewierszy varchar(100), -- zapytanie wstawiajace wiersze
@liczba numeric(3), --generowanie liczb losowych
@licznik numeric(1), --do petli
@opis varchar(1) --kategorie od A do E
begin
	set @tworzenietabeli='create table dane (opis varchar(1), wartosc numeric(3))'
	--exec(@tworzenietabeli) --robi sie tylko raz
	set @licznik=1
	while @licznik<=10
	begin
		select @liczba=cast(rand() *99+1 as numeric(3))
		--print @liczba
		if @liczba %5 =0 set @opis='E'
		else if @liczba %4=0 set @opis='D'
		else if @liczba % 3 =0 set @opis='C'
		else if @liczba %2 =0 set @opis='B'
		else set @opis='A'
		--print @opis
		--print 'insert into dane values ('''+@opis+''','+cast(@liczba as varchar(3))+')'
		set @wstawianiewierszy='insert into dane values ('''+@opis+''','+cast(@liczba as varchar(3))+')'
		exec(@wstawianiewierszy)
		set @licznik+=1
	end
end
go
select count(*) as dane from dane
select top 5 * from dane

select * from dane

--6
with zapytanie as
(select
case
when wartosc between 1 and 30 then 'male'
when wartosc between 31 and 70 then 'srednie'
else 'duze'
end as klasa_wartosci, opis, wartosc
from dane)
select klasa_wartosci, opis, sum(wartosc) as laczna_wartosc
from zapytanie
group by klasa_wartosci, opis
go

--dodatkowe do blokow anonimowych
declare @zapytanie as varchar(max)
begin
	set @zapytanie='
	with zapytanie as
	(select
	case
	when wartosc between 1 and 30 then ''male''
	when wartosc between 31 and 70 then ''srednie''
	else ''duze''
	end as klasa_wartosci, opis, wartosc
	from dane)
	select klasa_wartosci, opis, sum(wartosc) as laczna_wartosc
	from zapytanie
	group by klasa_wartosci, opis'
	exec(@zapytanie)
end
go
