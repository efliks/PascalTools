{ program by Super Sporty Baranek
  ------------------------------- }

program kalkulator;

var
   liczba_a, liczba_b, wynik, t : real;
   opcja : byte;
   n : integer;

{********************************************************************************}

{ liczy x^n }
function do_potegi(x : real; n : integer) : real;
var
   i : integer;
   r : real;
begin
   r := 1.0;
   for i := 1 to abs(n) do r := r * x;

   if n < 0 then r := 1.0 / r;

   do_potegi := r;
end;

{********************************************************************************}

{ wyswietla napis oraz menu na ekranie i zwraca opcje, ktora wybral uzytkownik }
function menu : byte;
var
   co_zrobic : byte;
begin
   writeln;
   writeln('      ^             ^^^    ^             ^^^                                   ');
   writeln('      ^               ^    ^               ^            ^                      ');
   writeln('      ^   ^   ^^^     ^    ^   ^  ^   ^    ^     ^^^   ^^^^^   ^^^   ^ ^^^     ');
   writeln('      ^  ^       ^    ^    ^  ^   ^   ^    ^        ^   ^     ^   ^  ^^  ^     ');
   writeln('      ^^^     ^^^^    ^    ^^^    ^   ^    ^     ^^^^   ^     ^   ^  ^         ');
   writeln('      ^ ^    ^   ^    ^    ^ ^    ^   ^    ^    ^   ^   ^     ^   ^  ^         ');
   writeln('      ^  ^   ^   ^    ^    ^  ^   ^  ^^    ^    ^   ^   ^     ^   ^  ^         ');
   writeln('      ^   ^   ^^^^^   ^    ^   ^  ^^^ ^    ^     ^^^^^   ^^^   ^^^   ^         ');
   writeln;
   writeln('-----------------------------------[ (c) 2004 Super Sporty Baranek ]-----------');
   writeln;
   writeln('A = ', liczba_a : 8 : 8, ', B = ', liczba_b : 8 : 8, ', WYNIK = ', wynik : 8 : 8);
   writeln;
   writeln('              ( 1) podaj liczbe A           ( 2) podaj liczbe B');
   writeln('              ( 3) dodawanie A + B          ( 4) odejmowanie A - B');
   writeln('              ( 5) mnozenie A * B           ( 6) dzielenie A / B');
   writeln('              ( 7) pierwiastek z A          ( 8) odwrotnosc A');
   writeln('              ( 9) potegowanie A            (10) sinus A');
   writeln('              (11) cosinus A                (12) tangens A');
   writeln('              (13) przypisz A = e           (14) ln A');
   writeln('              (15) przypisz A = Pi          (16) zamien A <-> B');
   writeln('              (17) przypisz A = WYNIK       (18) koniec programu');
   writeln;
   write('Podaj opcje >'); readln(co_zrobic);

   menu := co_zrobic;
end;

{********************************************************************************}

begin
   { powtarzaj dopoki nie nastapi wyjscie z programu }
   repeat
      { odczytaj, co uzytkownik chce zrobic }
      opcja := menu;

      { wykonaj stosowne dzialania/operacje }
      if opcja = 1 then
         begin
            write('A = '); readln(liczba_a);
         end
      else if opcja = 2 then
         begin
            write('B = '); readln(liczba_b);
         end
      else if opcja = 3 then
         wynik := liczba_a + liczba_b
      else if opcja = 4 then
         wynik := liczba_a - liczba_b
      else if opcja = 5 then
         wynik := liczba_a * liczba_b
      else if opcja = 6 then
         begin
            if liczba_b <> 0.0 then
               wynik := liczba_a / liczba_b
            else
               begin
                  write('Nie mozna dzielic przez zero ! Nacisnij ENTER... ');
                  readln;
               end;
         end
      else if opcja = 7 then
         begin
            if liczba_a < 0.0 then
               begin
                  write('Nie mozna liczyc pierwiastka z liczby ujemnej ! Nacisnij ENTER... ');
                  readln;
               end
            else
               wynik := sqrt(liczba_a);
         end
      else if opcja = 8 then
         begin
            if liczba_a = 0.0 then
               begin
                  write('Nie mozna obliczyc odwrotnosci ! Nacisnij ENTER... ');
                  readln;
               end
            else
               wynik := 1.0 / liczba_a;
         end
      else if opcja = 9 then
         begin
            write('Podaj wykladnik n : '); readln(n);
            wynik := do_potegi(liczba_a, n);
         end
      else if opcja = 10 then
         wynik := sin(liczba_a)
      else if opcja = 11 then
         wynik := cos(liczba_a)
      else if opcja = 12 then
         begin
            t := cos(liczba_a);
            if t = 0.0 then
               begin
                  write('Tangens nie istnieje ! Nacisnij ENTER... ');
                  readln;
               end
            else
               wynik := sin(liczba_a) / t;
         end
      else if opcja = 13 then
         liczba_a := exp(1.0)
      else if opcja = 14 then
         begin
            if liczba_a <= 0.0 then
               begin
                  write('Logarytm nie istnieje ! Nacisnij ENTER... ');
                  readln;
               end
            else
               wynik := ln(liczba_a);
         end
      else if opcja = 15 then
         liczba_a := 3.14159265359
      else if opcja = 16 then
         begin
            t := liczba_a;
            liczba_a := liczba_b;
            liczba_b := t;
         end
      else if opcja = 17 then
         liczba_a := wynik;

   until opcja = 18; { koniec }
end.
