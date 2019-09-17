/* This file is part of CNEMLIB.
 
Copyright (C) 2003-2011
Lounes ILLOUL (illoul_lounes@yahoo.fr)
Philippe LORONG (philippe.lorong@ensam.eu)
Arts et Metiers ParisTech, Paris, France
 
CNEMLIB is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

CNEMLIB is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

Please report bugs to illoul_lounes@yahoo.fr */

#pragma once

//----------------------------------------------------------------------------//

#include "C_Vec3d.h"

struct S_Tri_Front
{
    long Ind_Arete[3];
    C_Vec3d Normale;
};

struct S_Arete_Tri_Front
{
    long Ind_Noeud[2];
    long Ind_Tri[2];
};

bool Construction_Topologie_Frontiere
(long Nb_Noeud, double* Tab_Noeud,long Nb_Tri_Front,long* Tab_Ind_Noeud_Tri_Front,
 vector<S_Tri_Front>* P_List_Tri_Front,vector<S_Arete_Tri_Front>* P_List_Arete_Tri_Front,double* LAMMTF);
