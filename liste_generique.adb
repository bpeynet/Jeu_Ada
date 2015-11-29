with Ada.Unchecked_Deallocation;
with Ada.Text_IO; use Ada.Text_IO;

package body Liste_Generique is
   type Cellule is record
      Val: Element;
      Suiv: Liste;
   end record;

   type Iterateur_Interne is record
      Adresse: Liste;
      Suivant: Liste;
      --Precedent: Liste;
      --NB: Integer;
   end record;
   ----------------------------------------------------------

   procedure Liberer_Cellule is new Ada.Unchecked_Deallocation (Cellule, Liste);
   procedure Liberer_Iterateur is new Ada.Unchecked_Deallocation (Iterateur_Interne, Iterateur);

   ---------------------------------------------------------
   procedure Affiche_Liste (L : in Liste) is
      Curseur: Liste;
   begin
      Curseur:=L;
      while Curseur/=null loop
         Put(Curseur.Val);
         New_Line;
         Curseur:=Curseur.Suiv;
      end loop;
   end Affiche_Liste;

   procedure Insere_Tete (V : in Element; L : in out Liste) is
      N: Liste;
   begin
      N:=new Cellule'(V,L);
      L:=N;
   end Insere_Tete;

   procedure Libere_Liste(L : in out Liste) is
      Curseur, Tmp: Liste;
   begin
      Curseur:=L;
      while Curseur/=null loop
         Tmp:=Curseur.Suiv;
         Liberer_Cellule(Curseur);
         Curseur:=Tmp;
      end loop;
   end Libere_Liste;

   function Creer_Liste return Liste is
   begin
      return null;
   end Creer_Liste;

   function Creer_Iterateur (L : Liste) return Iterateur is
   begin
      if L/=null then return new Iterateur_Interne'(null,L);
      else return null;
      end if;
   end Creer_Iterateur;

   procedure Libere_Iterateur(It : in out Iterateur) is
   begin
      Liberer_Iterateur(It);
   end Libere_Iterateur;

   procedure Suivant(It : in out Iterateur) is
   begin
      if A_Suivant(It) then
         It.Adresse:=It.Suivant;
         It.Suivant:=It.Adresse.Suiv;
      else
         raise FinDeListe;
      end if;
   end Suivant;

   function Element_Courant(It : Iterateur) return Element is
   begin
      if It/=null then
         if It.Adresse/=null then
            return It.Adresse.Val;
         else
            if A_Suivant(It) then
               raise IT_Passe_Au_Suivant;
            else
               raise FinDeListe;
            end if;
         end if;
      else
         raise FinDeListe;
      end if;
   end Element_Courant;

   function A_Suivant(It : Iterateur) return Boolean is
   begin
      if It.Suivant/=null then return true;
      else return false;
      end if;
   end A_Suivant;

end Liste_Generique;

