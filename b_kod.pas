{ program by Super Sporty Baranek
  ------------------------------- }

program kodowanie;

const
   { stala okresla, ile nalezy dodac do kodu ASCII danego znaku, celem
   "zakodowania" tego znaku }
   STALA = 5;

var
   znaki, znaki_kod : string;

{********************************************************************************}

{ zamienia ciag s1 na zakodowany ciag s2 }
procedure koduj(s1 : string; var s2 : string);
var
   i, d : integer;
begin
   { pobierz dlugosc ciagu }
   d := ord(s1[0]);

   { przepisz dlugosc ciagu wejsciowego na wynikowy }
   s2[0] := chr(d);

   { koduj znak po znaku }
   for i := 1 to d do s2[i] := chr(ord(s1[i]) + STALA);
end;

{********************************************************************************}

{ program glowny }
begin
   writeln('Podaj ciag znakow, ktore chcesz zakodowac i nacisnij ENTER : ');
   readln(znaki);

   koduj(znaki, znaki_kod);

   writeln('Oto zakodowany ciag : ', znaki_kod);

   writeln;
   write('Nacisnij ENTER... '); readln;
end.
