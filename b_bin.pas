{ program by Super Sporty Baranek
  ------------------------------- }
  
program binaria;

type
   tr = array[1..100] of integer;

var
   imie, nazw : string;
   inum : longint; { numer indeksu to liczba zazwyczaj wieksza od 100000 wiec
   potrzeba typu longint }

{********************************************************************************}

{ zamienia liczbe n na jej zapis w systemie binarnym }
procedure int_bin(n : longint);
var
   r, i : longint;
   t : tr;
begin
   i := 0;

   repeat
      i := i + 1;

      { dziel liczbe przez 2, zapamietaj reszte z dzielenia }
      r := n mod 2;
      n := n div 2;

      { wpisz reszte do tablicy }
      t[i] := r;
   until ((n = 0) or (i = 100));

   { wypisz kolejno zera i jedynki }
   repeat
      write(t[i]);
      i := i - 1;
   until i = 0;
end;

{********************************************************************************}

{ zamienia lancuch znakowy (string) na znaki ASCII , a kazdy znak na zapis binarny }
procedure str_bin(s : string);
var
   str_len, i : integer;
begin
   { pobierz dlugosc lancucha }
   str_len := ord(s[0]);
   { kazdy znak w lancuchu zamieniaj na liczbe binarna }
   for i := 1 to str_len do int_bin(ord(s[i]));
end;

{********************************************************************************}

begin
   { pobierz dane }
   write('Podaj imie : '); readln(imie);
   write('Podaj nazwisko : '); readln(nazw);
   write('Podaj numer indeksu : '); readln(inum);
   writeln;

   write('Imie w binarnym : '); str_bin(imie);
   writeln;

   write('Nazwisko w binarnym : '); str_bin(nazw);
   writeln;

   write('Indeks w binarnym : '); int_bin(inum);
   writeln;

   writeln;
   write('Nacisnij ENTER... '); readln;
end.
