
{ Last Update: 22.11.2003 }

{ $APPTYPE CONSOLE}

program macierze;

uses
    Crt; {SysUtils;}

const
    MAC_ROZMIAR = 4; { <-- rozmiar macierzy i ilosc wspolrzednych wektora }

    AKT_MAC_A = 1;
    AKT_MAC_B = 2;

type
    macierz = array[1..MAC_ROZMIAR, 1..MAC_ROZMIAR] of real;

    { ten typ jest wykorzystywany w algorytmie transpozycji }
    macierz_b = array[1..MAC_ROZMIAR, 1..MAC_ROZMIAR] of boolean;

    wektor = array[1..MAC_ROZMIAR] of real;

var
    mac_a, mac_b, mac_w : macierz;
    wek1 : wektor;
    mnox : real;
    ktora_aktywna : real;
    akt_a, akt_b : string;
    menu_num : integer;
    txt_filename : string;

{----------------------------------------------------------------------}

{ tworzy macierz zerowa }
procedure mac_zerowa(var A : macierz);
var
    i, j : integer;
begin
    for i := 1 to MAC_ROZMIAR do
        for j := 1 to MAC_ROZMIAR do A[i, j] := 0.0;
end;

{----------------------------------------------------------------------}

{ tworzy macierz jednostkowa }
procedure mac_jednostkowa(var A : macierz);
var
    i, j : integer;
begin
    for i := 1 to MAC_ROZMIAR do
        for j := 1 to MAC_ROZMIAR do
            if i = j then A[i, j] := 1.0 else A[i, j] := 0.0;
end;

{----------------------------------------------------------------------}

{ kopiuje macierz A do macierzy B }
procedure mac_kopiuj(A : macierz; var B : macierz);
var
    i, j : integer;
begin
    for i := 1 to MAC_ROZMIAR do
        for j := 1 to MAC_ROZMIAR do B[i, j] := A[i, j];
end;

{----------------------------------------------------------------------}

procedure mac_mnozenie_przez_liczbe(var A : macierz; liczba : real);
var
  i, j : integer;
begin
  for i := 1 to MAC_ROZMIAR do
    for j := 1 to MAC_ROZMIAR do A[i, j] := A[i, j] * liczba;
end;

{----------------------------------------------------------------------}

{ wykonuje mnozenie macierzy przez macierz, tzn. A := A * B }
procedure mac_mnozenie(var A : macierz; B : macierz);
var
  i, j, m : integer;
  wynik : real;
  pom_mac : macierz;
begin
  for i := 1 to MAC_ROZMIAR do
      for j := 1 to MAC_ROZMIAR do
        begin
            wynik := 0;
            for m := 1 to MAC_ROZMIAR do
              wynik := wynik + A[i, m] * B[m, j];

            pom_mac[i, j] := wynik;
        end;

  mac_kopiuj(pom_mac, A);
end;

{----------------------------------------------------------------------}

{ czyta dane liczbowe i umieszcza je w wektorze }
procedure wek_inicjuj(var w : wektor);
var
    i : integer;
begin
    writeln('Podaj wspolrzedne wektora...');

    for i := 1 to MAC_ROZMIAR do readln(w[i]);
end;

{----------------------------------------------------------------------}

procedure wek_drukuj(w : wektor);
var
    i : integer;
begin
    write('[ ');
    for i := 1 to MAC_ROZMIAR do write(w[i] : 0 : 2, ' ');
    writeln(']');
end;

{----------------------------------------------------------------------}

{ drukuje macierz }
procedure mac_drukuj(m : macierz);
var
    i, j, k : integer;
    format_d, format_u, format, dodaj_minus : integer;
        min, max, pom : real;
    min_a, max_a, fff : integer;
        format_frac : string;
begin
    { znajdz najwieksza i najmniejsza liczbe w macierzy }
    min := 0.0;
    max := 0.0;
    for i := 1 to MAC_ROZMIAR do
        for j := 1 to MAC_ROZMIAR do
            begin
                pom := m[i, j];

                if pom < min then
                    min := pom
                else if pom > max then
                    max := pom;
            end;

    { znajdz dlugosc (ilosc znakow ASCII) najwiekszej dodatniej liczby }
    max_a := trunc(max);
    format_d := 0;
    repeat
        max_a := max_a div 10;
        format_d := format_d + 1;
    until max_a = 0;

    { znajdz dlugosc najmniejszej ujemnej liczby }
    if min < 0.0 then { jesli w macierzy sa liczby ujemne }
        begin
            min_a := trunc(abs(min));
            format_u := 1; { dodaj znak "-" }
            repeat
                min_a := min_a div 10;
                format_u := format_u + 1;
            until min_a = 0;
        end
    else
        format_u := 0;

    { format do dlugosc najwiekszej liczby w kodzie ASCII }
    if format_u > format_d then
        format := format_u
    else
        format := format_d;

    format := format + 1; { dodaj znak spacji dla oddzielenia liczb }

    { drukuj macierz }
    for i := 1 to MAC_ROZMIAR do
        begin
            write('|');
            for j := 1 to MAC_ROZMIAR do
                begin
                    fff := trunc(frac(abs(m[i, j])) * 100.0);
                    if fff < 10 then
                        format_frac := '.0'
                    else
                        format_frac := '.';
                        
                    write(trunc(m[i, j]) : format, format_frac, fff);    
                end;

            writeln(' |');
        end;
end;

{----------------------------------------------------------------------}

{ czyta dane liczbowe i zapisuje je w macierzy }
procedure mac_inicjuj(var m : macierz);
var
    i, j : integer;
    a : real;
begin
    writeln('Podaj dane do wypelnienia macierzy...');

    for i := 1 to MAC_ROZMIAR do
        for j := 1 to MAC_ROZMIAR do
            begin
                write(i, ',', j, ': ');
                readln(a);

                m[i, j] := a;
            end;
end;

{----------------------------------------------------------------------}

{ dodaje macierz A do macierzy B i pozostawia wynik w macierzy A }
procedure mac_dodaj(var A : macierz; B : macierz);
var
    i, j : integer;
begin
    for i := 1 to MAC_ROZMIAR do
        for j := 1 to MAC_ROZMIAR do
            A[i, j] := A[i, j] + B[i, j];
end;

{----------------------------------------------------------------------}

{ odejmuje od macierzy A macierz B i pozostawia wynik w macierzy A }
procedure mac_odejmij(var A : macierz; B : macierz);
var
    i, j : integer;
begin
    for i := 1 to MAC_ROZMIAR do
        for j := 1 to MAC_ROZMIAR do
            A[i, j] := A[i, j] - B[i, j];
end;

{----------------------------------------------------------------------}

{ transponuje macierz }
procedure mac_transpozycja(var A : macierz);
var
    i, j : integer;
    t : real;
    mac_pom : macierz_b;
begin
    for i := 1 to MAC_ROZMIAR do
        for j := 1 to MAC_ROZMIAR do mac_pom[i, j] := false;

    for i := 1 to MAC_ROZMIAR do
        for j := 1 to MAC_ROZMIAR do
            begin
                if mac_pom[i, j] = false then
                    begin
                        t := A[i, j];
                        A[i, j] := A[j, i];
                        A[j, i] := t;

                        mac_pom[i, j] := true;
                        mac_pom[j, i] := true;
                    end;
            end;
end;

{----------------------------------------------------------------------}

{ diagonalizacja wektora v do macierzy A}
procedure wek_diag(v : wektor; var A : macierz);
var
    i, j, pozycja : integer;
begin
    pozycja := 1;

    for i := 1 to MAC_ROZMIAR do
        begin
            for j := 1 to MAC_ROZMIAR do
                begin
                    if j = pozycja then
                        A[i, j] := v[i]
                    else
                        A[i, j] := 0.0;
                end;

            pozycja := pozycja + 1;
        end;
end;

{----------------------------------------------------------------------}

function mac_laplace(m : macierz; r : integer) : real;
var
    nr, i, p, q, c : integer;
    wynik, mnoznik : real;
    nowa_m : macierz;
begin
    nr := r - 1;
    if nr > 1 then
        begin
            wynik := 0.0;

            for i := 1 to r do
                begin
                    if ((i + 1) mod 2 = 0) then
                        mnoznik := 1.0
                    else
                        mnoznik := -1.0;


                    for p := 2 to r do
                        begin

                            c := 1;

                            for q := 1 to r do
                                begin
                                    if q <> i then
                                        begin
                                            nowa_m[p - 1, c] := m[p, q];
                                            c := c + 1;
                                        end;

                                end;

                        end;

                    wynik := wynik + mnoznik * m[1, i] * mac_laplace(nowa_m, nr);
                end;
        end
    else
        wynik := m[1, 1] * m[2, 2] - m[1, 2] * m[2, 1];

    mac_laplace := wynik;
end;

{----------------------------------------------------------------------}

{ liczy rekurencyjnie wyznacznik macierzy z rozwiniecia Laplace'a }
function mac_wyznacznik(m : macierz) : real;
begin
    mac_wyznacznik := mac_laplace(m, MAC_ROZMIAR);
end;

{----------------------------------------------------------------------}

{ liczy wyznacznik macierzy 3x3 metoda Sarrusa } {
function mac_sarrus(m : macierz) : real;
var
    t : integer;
begin
    t := MAC_ROZMIAR;
    if t <> 3 then
        mac_sarrus := 0
    else
        begin
            mac_sarrus := (m[1, 1] * m[2, 2] * m[3, 3]) +
            (m[1, 2] * m[2, 3] * m[3, 1]) + (m[1, 3] * m[2, 1] * m[3, 2]) -
            (m[1, 3] * m[2, 2] * m[3, 1]) - (m[1, 1] * m[2, 3] * m[3, 2]) -
            (m[1, 2] * m[2, 1] * m[3, 3]);
        end;
end; }

{----------------------------------------------------------------------}

{ zmienia macierz A na macierz do niej odwrotna }
procedure mac_odwrotna(var A : macierz);
var
    i, j, i2, j2, mi, mj : integer;
    det, d_ij, mnoznik : real;
    mac_pom, mac_mala : macierz;
begin
    det := mac_wyznacznik(A);
    if det = 0 then
        begin
            writeln('Nie mozna obliczyc macierzy odwrotnej bo wyznacznik = 0');
            mac_zerowa(A);
            exit;
        end;

    for i := 1 to MAC_ROZMIAR do
        for j := 1 to MAC_ROZMIAR do
            begin
                mac_jednostkowa(mac_mala);

                mi := 1;
                for i2 := 1 to MAC_ROZMIAR do
                    begin
                        if i2 = i then continue;

                        mj := 1;
                        for j2 := 1 to MAC_ROZMIAR do
                            begin
                                if j2 = j then continue;

                                mac_mala[mi, mj] := A[i2, j2];
                                mj := mj + 1;
                            end;

                        mi := mi + 1;
                    end;

                if (((i + j) mod 2) = 0) then
                    mnoznik := 1.0
                else
                    mnoznik := -1.0;

                d_ij := mac_wyznacznik(mac_mala) * mnoznik;
                mac_pom[i, j] := d_ij;
            end;
            
    mac_mnozenie_przez_liczbe(mac_pom, 1.0 / det);
    mac_transpozycja(mac_pom);
    mac_kopiuj(mac_pom, A);
end;

{----------------------------------------------------------------------}

{ zapisuje macierz do pliku }
procedure mac_zapisz(A : macierz; filename : string);
var
    f : text;
    i, j : integer;
begin
    assign(f, filename);
    rewrite(f);

    for i := 1 to MAC_ROZMIAR do
        for j := 1 to MAC_ROZMIAR do writeln(f, A[i, j]);

    close(f);

    writeln('Plik zostal zapisany.');
end;

{----------------------------------------------------------------------}

{ odczytuje macierz z pliku }
procedure mac_czytaj(var A : macierz; filename : string);
var
    f : text;
    i, j : integer;
begin
    assign(f, filename);
    reset(f);

    for i := 1 to MAC_ROZMIAR do
        for j := 1 to MAC_ROZMIAR do readln(f, A[i, j]);

    close(f);

    writeln('Plik zostal odczytany.');
end;

{----------------------------------------------------------------------}

procedure drukuj_menu;
begin
    if ktora_aktywna = AKT_MAC_A then
        begin
            akt_a := '(wybrana)';
            akt_b := '';
        end
    else
        begin
            akt_a := '';
            akt_b := '(wybrana)';
        end;

    writeln('                           ==========================');
    writeln('                            Macierze by Mickey Mouse ');
    writeln('                           ==========================');

    writeln('');
    writeln('Macierz A ', akt_a);
    mac_drukuj(mac_a);

    writeln('');
    writeln('Macierz B ', akt_b);
    mac_drukuj(mac_b);

    writeln('');
    writeln('( 1) wybierz macierz A   ( 2) wybierz macierz B   ( 3) inicjuj macierz');
    writeln('( 4) macierz zerowa      ( 5) macierz jednostkowa ( 6) wyznacznik');
    writeln('( 7) dodaj A + B         ( 8) odejmij A - B       ( 9) mnozenie przez liczbe');
    writeln('(10) mnozenie A * B      (11) transpozycja        (12) macierz odwrotna');
    writeln('(13) zapisz do pliku     (14) czytaj z pliku      (15) zamien A <-> B');
    writeln('(16) podaj wektor        (17) przepisz wynik      (18) koniec');
    
    writeln('');
    write('Podaj opcje : ');
end;

{----------------------------------------------------------------------}

procedure intro;
begin;
    writeln('');
    write('                                  ##                                            ');
    write('                                  ##                                            ');
    write('                                                                                ');
    write('    ########    ####     #### #  ####      #####  #### ###  #######   #####     ');
    write('     ## ## ##      ##   ##   ##    ##     ##   ##   ###  #  #   ##   ##   ##    ');
    write('     ## ## ##   #####   ##    #    ##     #######   ##         ##    #######    ');
    write('     ## ## ##  ##  ##   ##         ##     ##        ##        ##     ##         ');
    write('     ## ## ##  ##  ##   ##    #    ##     ##   ##   ##       ##   #  ##   ##    ');
    write('    ### ## ###  ######   #####  ########   #####  #######   #######   #####     ');
    writeln('');
    write('    ====================================[ by Mickey Mouse ]=================    ');
    writeln('');

    writeln('Nacisnij ENTER...');
    readln;
end;

{----------------------------------------------------------------------}

begin
    intro;

    mac_zerowa(mac_a);
    mac_zerowa(mac_b);
    mac_zerowa(mac_w);

    ktora_aktywna := AKT_MAC_A;

    repeat
        clrscr;
        drukuj_menu;

        readln(menu_num);

        if menu_num = 1 then
            ktora_aktywna := AKT_MAC_A
        else if menu_num = 2 then
            ktora_aktywna := AKT_MAC_B
        else if menu_num = 3 then
            begin
                if ktora_aktywna = AKT_MAC_A then
                    mac_inicjuj(mac_a)
                else
                        mac_inicjuj(mac_b);
            end
        else if menu_num = 4 then
            begin
                if ktora_aktywna = AKT_MAC_A then
                    mac_zerowa(mac_a)
                else
                        mac_zerowa(mac_b);    
            end
        else if menu_num = 5 then
            begin
                if ktora_aktywna = AKT_MAC_A then
                    mac_jednostkowa(mac_a)
                else
                        mac_jednostkowa(mac_b);    
            end
        else if menu_num = 6 then
            begin
                write('Wyznacznik =');
                if ktora_aktywna = AKT_MAC_A then
                    writeln(mac_wyznacznik(mac_a))
                else
                        writeln(mac_wyznacznik(mac_b));    
                readln;
            end
        else if menu_num = 7 then
            begin
                writeln('A + B =');

                mac_kopiuj(mac_a, mac_w);
                mac_dodaj(mac_w, mac_b);
                mac_drukuj(mac_w);

                readln;
            end
        else if menu_num = 8 then
            begin
                writeln('A - B =');

                mac_kopiuj(mac_a, mac_w);
                mac_odejmij(mac_w, mac_b);
                mac_drukuj(mac_w);

                readln;
            end
        else if menu_num = 9 then
            begin
                write('Podaj liczbe x : ');

                readln(mnox);

                if ktora_aktywna = AKT_MAC_A then
                    mac_kopiuj(mac_a, mac_w)
                else
                    mac_kopiuj(mac_b, mac_w);

                mac_mnozenie_przez_liczbe(mac_w, mnox);
                mac_drukuj(mac_w);

                readln;
            end
        else if menu_num = 10 then
            begin
                writeln('A * B =');

                mac_kopiuj(mac_a, mac_w);
                mac_mnozenie(mac_w, mac_b);
                mac_drukuj(mac_w);

                readln;
            end
        else if menu_num = 11 then
            begin
                writeln('Transpozycja =');

                if ktora_aktywna = AKT_MAC_A then
                    mac_kopiuj(mac_a, mac_w)
                else
                    mac_kopiuj(mac_b, mac_w);

                mac_transpozycja(mac_w);
                mac_drukuj(mac_w);

                readln;
            end
        else if menu_num = 12 then
            begin
                writeln('Macierz odwrotna =');

                if ktora_aktywna = AKT_MAC_A then
                    mac_kopiuj(mac_a, mac_w)
                else
                    mac_kopiuj(mac_b, mac_w);

                mac_odwrotna(mac_w);
                mac_drukuj(mac_w);

                readln;
            end
        else if menu_num = 15 then
            begin
                mac_kopiuj(mac_a, mac_w);
                mac_kopiuj(mac_b, mac_a);
                mac_kopiuj(mac_w, mac_b);
            end
        else if menu_num = 16 then
            begin
                wek_inicjuj(wek1);

                writeln('Wektor =');
                wek_drukuj(wek1);
                readln;

                writeln('Diagonalizacja wektora =');
                wek_diag(wek1, mac_w);
                mac_drukuj(mac_w);
                readln;
            end
        else if menu_num = 17 then
            begin
                if ktora_aktywna = AKT_MAC_A then
                    mac_kopiuj(mac_w, mac_a)
                else
                    mac_kopiuj(mac_w, mac_b);
            end
        else if menu_num = 13 then
            begin
                write('Zapisz jako : ');
                readln(txt_filename);

                if ktora_aktywna = AKT_MAC_A then
                    mac_zapisz(mac_a, txt_filename)
                else
                    mac_zapisz(mac_b, txt_filename);

                readln;
            end
        else if menu_num = 14 then
            begin
                write('Otworz plik : ');
                readln(txt_filename);

                if ktora_aktywna = AKT_MAC_A then
                    mac_czytaj(mac_a, txt_filename)
                else
                    mac_czytaj(mac_b, txt_filename);

                readln;
            end;


    until menu_num = 18;

    clrscr;
    writeln('Koniec programu.');
end.
