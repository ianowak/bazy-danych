--1. Nale�y utworzy� tablic� o nazwie TabLiczba, zawieraj�c� kolumny:
--identyfikator (autonumeracja),
--liczba typu liczbowego ca�kowitego (co najmniej z zakresu 0 do 1000),
--slownie typu tekstowego.

create table TabLiczba
(id int identity(1,1), 
liczba numeric(4,0),
slownie varchar(100))

INSERT INTO TabLiczba(liczba, slownie) VALUES (1,'jeden');

INSERT INTO TabLiczba(liczba, slownie) VALUES (2,'dwa');

INSERT INTO TabLiczba(liczba, slownie) VALUES (3,'trzy');

select * from TabLiczba

--2. Utworzy� procedur� o nazwie wyswietlDane, kt�ra wy�wietli wszystkie wiersze z tabeli o nazwie Liczba. Zweryfikowa� dzia�anie procedury.

create procedure wyswietlDane
as 
begin
	select * from TabLiczba
end

execute wyswietlDane -- mozna exec albo wyswietlDane ale to moze nie zadzialac w programie

--3. Utworzy� procedur� o nazwie dodajLiczbe, kt�ra przyjmuje dwa argumenty - liczb� oraz jej reprezentacj� s�own� i dodaje te argumenty jako kolejny wiersz tabeli TabLiczba.

create procedure dodajLiczbe --create proc
@numer numeric(4),
@sl varchar(100)
as 
begin
	insert into TabLiczba(liczba,slownie) values (@numer,@sl)
end
go

--4. Doda� liczby od 4 do 10 wykorzystuj�c procedur� dodajLiczbe.
--Podpowied�:

exec dodajLiczbe @Numer=4, @Sl='cztery';
exec dodajLiczbe @Numer=5, @Sl='pi��';
exec dodajLiczbe @Numer=6, @Sl='sze��';
exec dodajLiczbe @Numer=7, @Sl='siedem';
exec dodajLiczbe @Numer=8, @Sl='osiem';
exec dodajLiczbe @Numer=9, @Sl='dziewi��';
exec dodajLiczbe @Numer=10, @Sl='dziesi��';
go

select * from TabLiczba

--5. Utworzy� procedur� o nazwie procLiczbaSlownie, kt�ra za argument przyjmuje warto�� liczbow� i wy�wietla reprezentacj� s�own� tej liczby na podstawie danych z tabeli o nazwie TabLiczba. Zweryfikowa� dzia�anie procedury.

create proc liczbaSlownie
@argument numeric(4)
as 
begin
	select slownie from TabLiczba where liczba=@argument
end

exec liczbaSlownie @argument=5
go
--exec liczbaSlownie 5

--6. Utworzy� funkcj� o nazwie funkcjaLiczbaSlownie, kt�ra za argument przyjmuje warto�� liczbow� i zwraca reprezentacj� s�own� tej liczby w postaci tabeli, na podstawie danych z tabeli o nazwie TabLiczba. Zweryfikowa� dzia�anie.

create function funkcjaLiczbaSlownie
(@liczba numeric(4))
returns table
as return
(select slownie from TabLiczba where liczba=@liczba)
go

select * from funkcjaLiczbaSlownie(4)

create table tabela1(id int, numer int)
go
insert into tabela1 values(1,5)
insert into tabela1 values(2,8)
insert into tabela1 values(3,3)
go

create function funkcjaLiczbaSlownieSkalar
(@liczba numeric(4))
returns varchar(100)
as begin
	declare @slownie as varchar(100)
	select @slownie=slownie from TabLiczba where liczba=@liczba
	return @slownie
end
go

select *,dbo.funkcjaLiczbaSlownieSkalar(numer) from tabela1

--funkcje tabelaryczne: select * from
--funkcje skalarne: select

--7. Napisa� funkcj� o nazwie LiczbaWierszy, kt�ra zwr�ci liczb� wierszy zapisanych w tabeli o nazwie TabLiczba.

create function LiczbaWierszy()
returns numeric(3)
as 
begin
	declare @ilewierszy as numeric(3)
	select @ilewierszy=count(*) from TabLiczba
	return @ilewierszy
end

select dbo.liczbaWierszy() 
--do funkcji skalarnych trzeba uzyc schemat dbo

--8. Utworzy� procedur� o nazwie dodajTylkoLiczbe, kt�ra za argument przyjmuje warto�� liczbow�. Przed dodaniem liczby ma zosta� sprawdzona, czy warto�� argumentu jest z zakresu 20 do 99. Je�eli warunek ten zostanie spe�niony powinna zosta� dodana liczba wraz ze s�own� reprezentacj� np. dwadzie�cia trzy. Cz�� opisu powinna by� pobierana z opisu liczb od 1 do 9. Doda� kilka liczb z zakresu od 20 do 99.
go
create proc dodajTylkoLiczbe
@wartosc numeric(5)
as 
begin
	declare @slownie varchar(100)
	if @wartosc between 20 and 99
	begin
		if @wartosc between 20 and 29 set @slownie='dwadziescia'
		else if @wartosc between 30 and 39 set @slownie='trzydziesci'
		else if @wartosc between 40 and 49 set @slownie='czterdziesci'
		else if @wartosc between 50 and 59 set @slownie='piecdziesiat'
		else if @wartosc between 60 and 69 set @slownie='szescdziesiat'
		else if @wartosc between 70 and 79 set @slownie='siedemdziesiat'
		else if @wartosc between 80 and 89 set @slownie='osiemdziesiat'
		else if @wartosc between 90 and 99 set @slownie='dziewiecdziesiat'
		select @slownie+=space(1)+slownie from TabLiczba where @wartosc%10=liczba
		print @slownie
		insert into TabLiczba values (@wartosc, @slownie)
	end
end
go

exec dodajTylkoLiczbe 57
select dbo.LiczbaWierszy()

--9. Napisa� procedur� o nazwie DodajLiczby, kt�ra doda wszystkie liczby z okre�lonego zakresu u�ywaj�c w tym celu procedury o nazwie dodajTylkoLiczbe. Wywo�a� procedur� dla zakresu od 20 do 99.

create proc DodajLiczby
@liczba1 numeric(4), @liczba2 numeric(4)
as
begin
	while(@liczba1<=@liczba2)
	begin
		exec dodajTylkoLiczbe @liczba1
		set @liczba1+=1
	end
end
go

exec DodajLiczby 20,99
exec wyswietlDane

--10. Napisa� funkcj� o nazwie WyswietlDuplikatyLiczb, kt�ra w postaci tabeli z kolumnami liczba oraz liczba_wystapien, zwr�ci list� wszystkich duplikat�w liczb, jakie wyst�puj� w tabeli. Przetestowa� dzia�anie.

create function wyswietlDuplikatyLiczb()
returns table
as return
(
	select liczba, count(*) as liczba_wystapien
	from TabLiczba
	group by liczba
	having count(*)>1
)
go

select * from wyswietlDuplikatyLiczb()

--11. Napisa� procedur� UsunLiczbe, usuwaj�c� liczb� podan� jako argument wywo�ania procedury. Przetestowa� dzia�anie.

create proc UsunLiczbe
@liczba numeric(4)
as
begin
	delete from TabLiczba where liczba=@liczba
end

select * from wyswietlDuplikatyLiczb()
exec UsunLiczbe 57

exec dodajTylkoLiczbe 57

select liczba, slownie from TabLiczba order by liczba