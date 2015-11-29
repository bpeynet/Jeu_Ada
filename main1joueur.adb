with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Puissance4;
with Participant;
with Partie;
with Liste_Generique;
with Moteur_Jeu;

use Ada.Text_IO;
use Ada.Integer_Text_IO;
use Participant;

procedure Main1Joueur is

   package MyPuissance4 is new Puissance4(5,5,3);
   Nom1: String(1..20);
   Nom2: String := "L'ordinateur";
   Last1: Natural;
   use MyPuissance4;

   package Liste_Coups is new Liste_Generique(Element => MyPuissance4.Coup,
                                              Put     => MyPuissance4.Affiche_Coup);
   use Liste_Coups;

   function Coups_Possibles(E : MyPuissance4.Etat; J : Joueur) return Liste_Coups.Liste is
      Possibilites: Liste_Coups.Liste;
      C: MyPuissance4.Coup;
      K: Integer;
   begin
      Possibilites:=Creer_Liste;
      C.Qui:=J;
      K:=E.G'First(1);
      for I in reverse E.G'First(2)..E.G'Last(2) loop
         if E.G(E.G'Last(1),I)=0 then
            while E.G(K,I)/=0 loop
               K:=K+1;
            end loop;
            C.Coordonnees:=(K,I);
            Insere_Tete(C,Possibilites);
         end if;
      end loop;
      return Possibilites;
   end Coups_Possibles;

   function Est_Dedans(G: access Grille; X: Integer; Y: Integer) return Boolean is
   begin
      if X>=G'First(1) and X<=G'Last(1) and Y>=G'First(2) and Y<=G'Last(2) then
         return True;
      else return False;
      end if;
   end Est_Dedans;

   function Voisinage(G: access Grille; X: Integer; Y: Integer) return Integer is
      Total: Integer;
   begin
      Total:=0;
      if Est_Dedans(G,X+1,Y+1) then
         if G(X,Y)=G(X+1,Y+1) then
            Total:=Total+2;
         elsif G(X+1,Y+1)=0 then
            Total:=Total+1;
         end if;
      end if;
      if Est_Dedans(G,X+1,Y) then
         if G(X,Y)=G(X+1,Y) then
            Total:=Total+2;
         elsif G(X+1,Y)=0 then
            Total:=Total+1;
         end if;
      end if;
      if Est_Dedans(G,X+1,Y-1) then
         if G(X,Y)=G(X+1,Y) then
            Total:=Total+2;
         elsif G(X+1,Y)=0 then
            Total:=Total+1;
         end if;
      end if;
      if Est_Dedans(G,X,Y+1) then
         if G(X,Y)=G(X,Y+1) then
            Total:=Total+2;
         elsif G(X,Y+1)=0 then
            Total:=Total+1;
         end if;
      end if;
      if Est_Dedans(G,X,Y-1) then
         if G(X,Y)=G(X,Y-1) then
            Total:=Total+2;
         elsif G(X,Y-1)=0 then
            Total:=Total+1;
         end if;
      end if;
      return Total;
   end Voisinage;

   function Eval(E : Etat) return Integer is
      Avantage_Ordi, Avantage_Joueur: Integer;
   begin
      if Est_Gagnant(E,Joueur1) then return -100;
      elsif Est_Gagnant(E,Adversaire(Joueur2)) then return 100;
      elsif Est_Nul(E) then return 0;
      else
         Avantage_Joueur:=0;
         Avantage_Ordi:=0;
         for I in E.G'First(1)..E.G'Last(1) loop
            for J in E.G'First(2)..E.G'Last(2) loop
               if E.G(I,J)=1 then
                  Avantage_Joueur:=Avantage_Joueur+Voisinage(E.G,I,J);
               elsif E.G(I,J)=2 then
                  Avantage_Ordi:=Avantage_Ordi+Voisinage(E.G,I,J);
               end if;
            end loop;
         end loop;
      end if;
      return Avantage_Ordi-Avantage_Joueur;
   end Eval;

begin
   Put("Entrez le nom du joueur: ");
   Get_Line(Nom1,Last1);

   declare

      package IA is new Moteur_Jeu(Etat            => MyPuissance4.Etat,
                                   Coup            => MyPuissance4.Coup,
                                   Etat_Suivant    => MyPuissance4.Jouer,
                                   Est_Gagnant     => MyPuissance4.Est_Gagnant,
                                   Est_Nul         => MyPuissance4.Est_Nul,
                                   Affiche_Coup    => MyPuissance4.Affiche_Coup,
                                   Liste_Coups     => Liste_Coups,
                                   Coups_Possibles => Coups_Possibles,
                                   Eval            => Eval,
                                   Profondeur      => 3,
                                   JoueurMoteur    => Joueur2);
      -- definition d'une partie entre L'ordinateur en Joueur 1 et un humain en Joueur 2
      package MyPartie is new Partie(MyPuissance4.Etat,
                                     MyPuissance4.Coup,
                                     Nom1(1..Last1),
                                     Nom2,
                                     MyPuissance4.Jouer,
                                     MyPuissance4.Est_Gagnant,
                                     MyPuissance4.Est_Nul,
                                     MyPuissance4.Afficher,
                                     MyPuissance4.Affiche_Coup,
                                     MyPuissance4.Demande_Coup_Joueur1,
                                     IA.Choix_Coup);
      use MyPartie;

      P: MyPuissance4.Etat;

   begin
      --Put(3,0);
      Put_Line("3x3 - Puissance 4");
      Put_Line(Nom1(1..Last1) & " : X");
      Put_Line(Nom2 & " : O");New_Line;

      MyPuissance4.Initialiser(P);

      Joue_Partie(P, Joueur2);
   end;
   Get_Line(Nom1,Last1);
end Main1Joueur;
