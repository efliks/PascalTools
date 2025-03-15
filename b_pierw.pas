{ program by Super Sporty Baranek
  ------------------------------- }

program liczby_pierwsze;

const
   { maksymalna ilosc liczb do przeszukania }
   MAX = 20000;

type
   { tablica liczb }
   liczby = array[1..MAX] of integer;

var
   t : liczby;
   i, j, ile_znaleziono, ktora_teraz, c : integer;
   ok : boolean;
   plik : text;

begin
   writeln('Wyszukuje 200 liczb pierwszych... ');

   { zastosujemy algorytm "Sito Eratostenesa" }

   { wypelniamy po kolei tablice liczbami. Zaczynamy od 2 bo
   liczba 1 ma tylko jeden dzielnik i nie moze byc rozpatrywana jako
   pierwsza lub nie-pierwsza }
   for i := 1 to MAX do t[i] := i + 1;

   ile_znaleziono := 0;
   ktora_teraz := 0; { ktora liczba z tablicy jest badana }

   repeat
      ok := false;
      repeat
         inc(ktora_teraz);
         c := t[ktora_teraz];

         { jesli ta liczba zostala wczesniej wyzerowana to znaczy, ze
         NIE byla pierwsza. Znajdz nastepna }
         if c <> 0 then ok := true;
      until ok = true;

      for i := c to MAX do
         begin
            { wykresl liczby, ktore sa podzielne przez badana liczbe }
            if t[i] mod c = 0 then t[i] := 0;
         end;

      inc(ile_znaleziono);
   until ile_znaleziono = 200;

   { zapisz do pliku }
   assign(plik, 'pierwsze.txt');
   rewrite(plik);

   j := 1;
   for i := 1 to MAX do
      begin
         if t[i] <> 0 then
            begin
               writeln(plik, t[i]);

               inc(j);
               if j > 200 then break;
            end;
      end;

   close(plik);


   writeln('Liczby zostaly zapisane do pliku pierwsze.txt !');

   write('Nacisnij ENTER... '); readln;
end.
