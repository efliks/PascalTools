{ program by Super Sporty Baranek
  ------------------------------- }

program doskonala;

type
   ttt = array[1..100] of integer;

var
   x, ile_liczb, n_dz, i, suma : integer;
   dzielniki : ttt;

{********************************************************************************}

begin
   writeln('Wyszukuje liczby doskonale. Czekaj...');

   x := 1;
   ile_liczb := 0;
   
   repeat
      { obliczanie dzielnikow }
      n_dz := 0;
      for i := 1 to x do
         begin
            if (x mod i = 0) then
               begin
                  inc(n_dz);
                  dzielniki[n_dz] := i;
               end;
         end;

      { sumuje dzielniki }
      suma := 0;
      dec(n_dz);
      for i := 1 to n_dz do suma := suma + dzielniki[i];

      { sprawdzenie czy suma dzielnikow daje liczbe x }
      if suma = x then
         begin
            write('Znaleziono : ', x);

            write(' (');
            for i := 1 to n_dz do
               begin
                  if i > 1 then write(' + ');
                  write(dzielniki[i]);
               end;
            writeln(')');

            inc(ile_liczb);
            if ile_liczb = 3 then break;
         end;

      inc(x);
   until 1 <> 1;
   
   write('Nacisnij ENTER...'); readln;
end.
