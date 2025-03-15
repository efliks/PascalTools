{ program by Super Sporty Baranek
  ------------------------------- }

program totek;

type
   { tablica wygenerowanych liczb }
   tab = array[1..6] of byte;

var
   i, j, n : integer;
   ok : boolean;
   t : tab;

{********************************************************************************}

begin
   write('TOTEK : generuje 6 liczb sposrod 49... ');

   { inicjuj generator liczb losowych }
   randomize;

   { znajdz 6 liczb }
   for i := 1 to 6 do
      begin
         repeat
            n := random(49) + 1; { zakres : 1 <= c <= 49 }

            { jesli to pierwsza liczba, szukaj nastepnej }
            if i = 1 then break;

            ok := true;

            { sprawdz, czy liczba nie byla wylosowana wczesniej }
            for j := 1 to i do
               begin
                  { byla wylosowana, losuj jeszcze raz }
                  if t[j] = n then
                     begin
                        ok := false;
                        break;
                     end;
               end;
         until ok = true;

         { wpisz do tablicy }
         t[i] := n;

         { dodaj przecinek zeby bylo ladnie }
         if i > 1 then write(', ');

         { napisz liczbe }
         write(n);
      end;

   writeln;

   write('Nacisnij ENTER... '); readln;
end.
