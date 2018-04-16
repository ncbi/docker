// gff_check.cpp

/*===========================================================================
*
*                            PUBLIC DOMAIN NOTICE                          
*               National Center for Biotechnology Information
*                                                                          
*  This software/database is a "United States Government Work" under the   
*  terms of the United States Copyright Act.  It was written as part of    
*  the author's official duties as a United States Government employee and 
*  thus cannot be copyrighted.  This software/database is freely available 
*  to the public for use. The National Library of Medicine and the U.S.    
*  Government have not placed any restriction on its use or reproduction.  
*                                                                          
*  Although all reasonable efforts have been taken to ensure the accuracy  
*  and reliability of the software and data, the NLM and the U.S.          
*  Government do not and cannot warrant the performance or results that    
*  may be obtained by using this software or data. The NLM and the U.S.    
*  Government disclaim all warranties, express or implied, including       
*  warranties of performance, merchantability or fitness for any particular
*  purpose.                                                                
*                                                                          
*  Please cite the author in any work or product based on this material.   
*
* ===========================================================================
*
* Author: Vyacheslav Brover
*
* File Description:
*   Check the correctness of a .gff-file
*
*/
   
   
#undef NDEBUG 
#include "common.inc"

#include "common.hpp"
using namespace Common_sp;
#include "gff.hpp"
using namespace GFF_sp;



namespace 
{




struct ThisApplication : Application
{
  ThisApplication ()
    : Application ("Check the correctness of a .gff-file. Exit with an error if it is incorrect.")
    {
      addPositional ("gff", ".gff-file");
      addKey ("fasta", "Protein FASTA file");
    }



  void body () const final
  {
    const string gffName   = getArg ("gff");
    const string fastaName = getArg ("fasta");
    
    const Gff gff (gffName);
    
    if (! fastaName. empty ())
    {
	    StringVector seqids;  seqids. reserve (10000);  // PAR
		  LineInput f (fastaName /*, 100 * 1024, 1*/);
		  while (f. nextLine ())
		    if (! f. line. empty ())
		    	if (f. line [0] == '>')
		    	{
		    		istringstream iss (f. line. substr (1));
		    		string s;
		    		iss >> s;
		    		if (! s. empty ())
		    			seqids << s;
		    	}
		  for (const string& seqid : seqids)
		  	if (! contains (gff. seqid2cdss, seqid))
		  		throw runtime_error ("Protein id '" + seqid + "' is not in the .gff-file");
    }    
  }
};



}  // namespace



int main (int argc, 
          const char* argv[])
{
  ThisApplication app;
  return app. run (argc, argv);  
}



