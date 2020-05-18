--1. Nale¿y utworzyæ tablicê o nazwie TabLiczba, zawieraj¹c¹ kolumny:
--identyfikator (autonumeracja),
--liczba typu liczbowego ca³kowitego (co najmniej z zakresu 0 do 1000),
--slownie typu tekstowego.

create table TabLiczba
(id int identity(1,1), 
liczba numeric(4,0),
slownie varchar(100))

INSERT INTO TabLiczba(liczba, slownie) VALUES (1,'jeden');

INSERT INTO TabLiczba(liczba, slownie) VALUES (2,'dwa');

INSERT INTO TabLiczba(liczba, slownie) VALUES (3,'trzy');

select * from TabLiczba

--2. Utworzyæ procedurê o nazwie wyswietlDane, która wyœwietli wszystkie wiersze z tabeli o nazwie Liczba. Zweryfikowaæ dzia³anie procedury.

create procedure wyswietlDane
as 
begin
	select * from TabLiczba
end

execute wyswietlDane -- mozna exec albo wyswietlDane ale to moze nie zadzialac w programie

--3. Utworzyæ procedurê o nazwie dodajLiczbe, która przyjmuje dwa argumenty - liczbê oraz jej reprezentacjê s³own¹ i dodaje te argumenty jako kolejny wiersz tabeli TabLiczba.

create procedure dodajLiczbe --create proc
@numer numeric(4),
@sl varchar(100)
as 
begin
	insert into TabLiczba(liczba,slownie) values (@numer,@sl)
end
go

--4. Dodaæ liczby od 4 do 10 wykorzystuj¹c procedurê dodajLiczbe.
--PodpowiedŸ:

exec dodajLiczbe @Numer=4, @Sl='cztery';
exec dodajLiczbe @Numer=5, @Sl='piêæ';
exec dodajLiczbe @Numer=6, @Sl='szeœæ';
exec dodajLiczbe @Numer=7, @Sl='siedem';
exec dodajLiczbe @Numer=8, @Sl='osiem';
exec dodajLiczbe @Numer=9, @Sl='dziewiêæ';
exec dodajLiczbe @Numer=10, @Sl='dziesiêæ';
go

select * from TabLiczba

--5. Utworzyæ procedurê o nazwie procLiczbaSlownie, która za argument przyjmuje wartoœæ liczbow¹ i wyœwietla reprezentacjê s³own¹ tej liczby na podstawie danych z tabeli o nazwie TabLiczba. Zweryfikowaæ dzia³anie procedury.

create proc liczbaSlownie
@argument numeric(4)
as 
begin
	select slownie from TabLiczba where liczba=@argument
end

exec liczbaSlownie @argument=5
go
--exec liczbaSlownie 5

--6. Utworzyæ funkcjê o nazwie funkcjaLiczbaSlownie, która za argument przyjmuje wartoœæ liczbow¹ i zwraca reprezentacjê s³own¹ tej liczby w postaci tabeli, na podstawie danych z tabeli o nazwie TabLiczba. Zweryfikowaæ dzia³anie.

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

--7. Napisaæ funkcjê o nazwie LiczbaWierszy, która zwróci liczbê wierszy zapisanych w tabeli o nazwie TabLiczba.

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

--8. Utworzyæ procedurê o nazwie dodajTylkoLiczbe, która za argument przyjmuje wartoœæ liczbow¹. Przed dodaniem liczby ma zostaæ sprawdzona, czy wartoœæ argumentu jest z zakresu 20 do 99. Je¿eli warunek ten zostanie spe³niony powinna zostaæ dodana liczba wraz ze s³own¹ reprezentacj¹ np. dwadzieœcia trzy. Czêœæ opisu powinna byæ pobierana z opisu liczb od 1 do 9. Dodaæ kilka liczb z zakresu od 20 do 99.
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

--9. Napisaæ procedurê o nazwie DodajLiczby, która doda wszystkie liczby z okreœlonego zakresu u¿ywaj¹c w tym celu procedury o nazwie dodajTylkoLiczbe. Wywo³aæ procedurê dla zakresu od 20 do 99.

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

--10. Napisaæ funkcjê o nazwie WyswietlDuplikatyLiczb, która w postaci tabeli z kolumnami liczba oraz liczba_wystapien, zwróci listê wszystkich duplikatów liczb, jakie wystêpuj¹ w tabeli. Przetestowaæ dzia³anie.

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

--11. Napisaæ procedurê UsunLiczbe, usuwaj¹c¹ liczbê podan¹ jako argument wywo³ania procedury. Przetestowaæ dzia³anie.

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