with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO; use Ada.Text_IO;

package body Puissance4 is

   function Jouer(E : Etat; C : Coup) return Etat is
      Nouvel_Etat: Etat;
   begin
      Nouvel_Etat.G:=new Grille;
      Nouvel_Etat.G.all:=E.G.all;
      Nouvel_Etat.dernier_coup:=C;
      if C.Qui=Joueur1 then Nouvel_Etat.G(C.Coordonnees(1),C.Coordonnees(2)):=1;
      elsif C.Qui=Joueur2 then Nouvel_Etat.G(C.Coordonnees(1),C.Coordonnees(2)):=2;
         --else raise Erreur;
      end if;
      return Nouvel_Etat;
   end Jouer;

   function Est_Gagnant(E : in Etat; Jo : in Joueur) return Boolean is
      Valeur_Jo: Integer;
   begin
      if Jo=Joueur1 then Valeur_Jo:=1;
      elsif Jo=Joueur2 then Valeur_Jo:=2;
      else return False;
      end if;
      for I in E.G'First(1)..E.G'Last(1) loop
         for J in E.G'First(2)..E.G'Last(2) loop
            if E.G(I,J)=Valeur_Jo then
               if Alignement(E.G,I,J,I-1,J-1,1) or
                 Alignement(E.G,I,J,I-1,J,1) or
                 Alignement(E.G,I,J,I-1,J+1,1) or
                 Alignement(E.G,I,J,I,J-1,1) or
                 Alignement(E.G,I,J,I,J+1,1) or
                 Alignement(E.G,I,J,I+1,J-1,1) or
                 Alignement(E.G,I,J,I+1,J,1) or
                 Alignement(E.G,I,J,I+1,J+1,1) then
                  return True;
               end if;
            end if;
         end loop;
      end loop;
      return False;
   end Est_Gagnant;

   function Alignement(G: access Grille; I: Integer; J: Integer; SI: Integer; SJ: Integer; Compteur: Integer) return Boolean is
   begin--Compteur doit partir de 1
      if I>=G'First(1) and I<=G'Last(1) and J>=G'First(2) and J<=G'Last(2) and
        SI>=G'First(1) and SI<=G'Last(1) and SJ>=G'First(2) and SJ<=G'Last(2) then
         if Compteur=Nb_alignes then return True;
         else
            if G(SI,SJ)=G(I,J) then 
               if Alignement(G,SI,SJ,2*SI-I,2*SJ-J,Compteur+1) or
                 Alignement(G,2*I-SI,2*J-SJ,I,J,Compteur+1) then
                  return True;
               else return False;
               end if;
            else return False;
            end if;
         end if;
      else return False;
      end if;
   end Alignement;

   -- Indique si l'etat courant est un status quo (match nul)
   function Est_Nul(E : Etat) return Boolean is
   begin
      for I in E.G'First(1)..E.G'Last(1) loop
         for J in E.G'First(2)..E.G'Last(2) loop
            if E.G(I,J)/=1 and E.G(I,J)/=2 then
               return False;
            end if;
         end loop;
      end loop;
      if not Est_Gagnant(E,Joueur1) and not Est_Gagnant(E,Joueur2) then
         return True;
      else return False;
      end if;
   end Est_Nul;

   -- Fonction d'affichage de l'etat courant du jeu
   procedure Afficher(E : Etat) is
   begin
      for I in reverse E.G'First(1)..E.G'Last(1) loop
         for J in E.G'First(2)..E.G'Last(2) loop
            case E.G(I,J) is
               when 0 => Put("   ");
               when 1 => Put(" X ");
               when 2 => Put(" O ");
            end case;
            Put("|");
         end loop;
         New_Line;
      end loop;
      New_Line;
   end Afficher;

   -- Affiche a l'ecran le coup passe en parametre
   procedure Affiche_Coup(C : in Coup) is
   begin
      Put_Line("("& Integer'Image(C.Coordonnees(1)) & "," & Integer'Image(C.Coordonnees(2)) & ")");
      Put_Line("Jouer dans la colonne" & Integer'Image(C.Coordonnees(2)));
   end Affiche_Coup;

   --     -- Retourne le prochaine coup joue par le joueur1
   --     function Demande_Coup_Joueur1(E : Etat) return Coup is
   --        Ind_Colonne, I: Integer;
   --        C: Coup;
   --     begin
   --        I:=E.G'Last(1)+1;
   --        while I>E.G'Last(1) loop
   --           Put_Line(", dans quelle colonne jouer ?");
   --           Get(Ind_Colonne);
   --           I:=E.G'First(1);
   --           while Ind_Colonne<=E.G'Last(2) and Ind_Colonne>=E.G'First(2) and I<=E.G'Last(1) and E.G(I,Ind_Colonne)/=0 loop
   --              I:=I+1;
   --           end loop;
   --        end loop;
   --        C.Coordonnees:=(I,Ind_Colonne);
   --        C.Qui:=Joueur1;
   --        return C;
   --     end Demande_Coup_Joueur1;

   function Demande_Coup_Joueur1(E : Etat) return Coup is
      Ind_Colonne, I: Integer;
      C: Coup;

   begin
      I:=E.G'First(1);

      --On demande au joueur où il veut jouer
      Put_Line("Dans quelle colonne jouer ?");
      Get(Ind_Colonne);

      --Si la colonne choisit n'existe pas ou qu'elle est pleine
      while Ind_Colonne not in E.G'First(2)..E.G'Last(2) or else E.G(E.G'Last(1),Ind_Colonne)/= 0 loop

         if Ind_Colonne not in E.G'First(2)..E.G'Last(2) then
            Put_Line("La colonne n'existe pas, entrez le numéro d'une colonne existante :");
         else
            Put_Line("La colonne est pleine, choississez en une autre :");
         end if;

         Get(Ind_Colonne);
      end loop;

      --On doit faire "tomber" le jeton ie trouver la première ligne non occupé de la colonne choisit par l'utilisateur
      while   E.G(I,Ind_Colonne) /= 0 loop
         I:=I+1;
      end loop;

      --On remplit les arguments de "Coup"
      C.Coordonnees:=(I,Ind_Colonne);
      C.Qui := Joueur1;
      Affiche_Coup(C);
      return C;

   end Demande_Coup_Joueur1;
   
   
   --     -- Retourne le prochaine coup joue par le joueur2
   --     function Demande_Coup_Joueur2(E : Etat) return Coup is
   --        Ind_Colonne, I: Integer;
   --        C: Coup;
   --     begin
   --        I:=E.G'Last(1)+1;
   --        while I>E.G'Last(1) loop
   --           Put_Line(", dans quelle colonne jouer ?");
   --           Get(Ind_Colonne);
   --           I:=E.G'First(1);
   --           while Ind_Colonne<=E.G'Last(2) and Ind_Colonne>=E.G'First(2) and I<=E.G'Last(1) and E.G(I,Ind_Colonne)/=0 loop
   --              I:=I+1;
   --           end loop;
   --        end loop;
   --        C.Coordonnees:=(I,Ind_Colonne);
   --        C.Qui:=Joueur2;
   --        return C;
   --     end Demande_Coup_Joueur2;

   -- Retourne le prochaine coup joue par le joueur2
   function Demande_Coup_Joueur2(E : Etat) return Coup is
      Ind_Colonne, I: Integer;
      C: Coup;

   begin
      I:=E.G'First(1);

      --On demande au joueur où il veut jouer
      Put_Line("Dans quelle colonne jouer ?");
      Get(Ind_Colonne);

      --Si la colonne choisit n'existe pas ou qu'elle est pleine
      while Ind_Colonne not in E.G'First(2)..E.G'Last(2) or else E.G(E.G'Last(1),Ind_Colonne)/= 0 loop

         if Ind_Colonne not in E.G'First(2)..E.G'Last(2) then
            Put_Line("La colonne n'existe pas, entrez le numéro d'une colonne existante :");
         else
            Put_Line("La colonne est pleine, choississez en une autre :");
         end if;

         Get(Ind_Colonne);
      end loop;

      --On doit faire "tomber" le jeton ie trouver la première ligne non occupé de la colonne choisit par l'utilisateur
      while   E.G(I,Ind_Colonne) /= 0 loop
         I:=I+1;
      end loop;

      --On remplit les arguments de "Coup"
      C.Coordonnees:=(I,Ind_Colonne);
      C.Qui := Joueur2;
      Affiche_Coup(C);
      return C;

   end Demande_Coup_Joueur2;

   procedure Initialiser (E: in out Etat) is
   begin
      E.G:=new Grille;
      E.G.all:=(others=>(others=>0));
      E.dernier_coup.Coordonnees:=(-1,-1);
   end Initialiser;

   procedure Put(E: in Element) is
   begin null;
   end Put;

end Puissance4;
