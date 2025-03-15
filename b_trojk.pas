{ program by Super Sporty Baranek
  ------------------------------- }

program trojkowy;

const
	{ maksymalna ilosc cyfr jakie program moze wypisac podczas zamieniania
	na inny system liczbowy }
	MAX_R = 100;

type
	{ tablica, ktora zawiera kolejne reszty z dzienia liczby przez
	16 lub 3 }
	tab_r = array[1..MAX_R] of byte;

var
	{ liczba wprowadzana przez uzytkownika }
	liczba : integer;

{********************************************************************************}

{ zamienia liczbe n na jej zapis w systemie trojkowym i wypisuje na ekranie.
Maksymalnie moze wypisac MAX cyfr }
procedure sys_3(n : integer);
var
	r, i : integer;
	t : tab_r;
begin
	i := 0;

	repeat
		inc(i);

		{ dziel liczbe przez 3, zapamietaj reszte z dzielenia }
		r := n mod 3;
		n := n div 3;

		{ wpisz reszte do tablicy }
		t[i] := r;
	until ((n = 0) or (i = MAX_R));

	{ i zawiera teraz ilosc podzialow = ilosc reszt z dzielenia }

	{ tablica zostala wypelniona. Teraz zaczynamy od konca tablicy i
	wypisujemy kolejne cyfry }
	repeat
		write(t[i]);
		dec(i);
	until i = 0;
end;

{********************************************************************************}

{ zamienia liczbe na jej zapis w systemie szesnastkowym }
procedure sys_16(n : integer);
var
	r, i : integer;
	c : byte;
	t : tab_r;
begin
	i := 0;

	repeat
		inc(i);

		{ dziel liczbe "n" przez 16 i zapamietaj reszte z dzielenia }
		r := n mod 16;
		n := n div 16;

		{ zapamietaj reszte w tablicy }
		t[i] := r;
	until ((n = 0) or (i = MAX_R)); { powtarzaj tak dlugo az skonczysz dzielenie }

	{ wypisz kolejne cyfry z tablicy w odwrotnej (poprawnej) kolejnosci }
	repeat
		c := t[i];

		if c > 9 then
			{ jesli reszta z dzielenia byla wieksza od 9, zamien ja na
			symbol literowy A..F }
			write(chr(c - 10 + ord('A')))
		else
			write(c);

		dec(i);
	until i = 0;
end;

{********************************************************************************}

{ program glowny }
begin
	{ pobiera liczbe od uzytkownika }
	write('Podaj liczbe naturalna : '); readln(liczba);

	if liczba < 0 then
		writeln('To nie jest liczba naturalna !')
	else
		begin
			write('W systemie trojkowym : ');
			sys_3(liczba);
			writeln;

			write('W systemie szesnastkowym : ');
			sys_16(liczba);
			writeln;
		end;

	write('Nacisnij ENTER... '); readln;
end.
