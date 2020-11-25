/*==============================================================================

						MAKING ANALYTICS REUSABLE
						Javier Parada Gomez Urquiza
							From Luisa
							  September 23, 2020
							
					STATA MARKDOWN MASTER DO FILE
							 
==============================================================================*/

/*******************************************************************************
	PART 0: Select sections to run
*******************************************************************************/

	local packages		1
	local paths			1
	local document		1

/*******************************************************************************
	PART 1: Install necessary packages
*******************************************************************************/

	if `packages' {
		
		* Install markstat to use Stata markdown
		ssc install markstat, replace

		* Install whereis to make markstat work
		ssc install whereis, replace
		
		* Install other commands we will use for this session
		ssc install estout, replace
		ssc install unique, replace
		
	}
	
/*******************************************************************************
	PART 2: Set folder paths
*******************************************************************************/

	if `paths' {

		* Tell Stata where to find the relevant programs	
		whereis pdflatex 			"/Library/TeX/texbin/pdflatex"
		whereis pandoc 				"/Users/javierparada/opt/anaconda3/bin/pandoc"
		
		* Workshop folder
		global	RT2					"/Users/javierparada/Documents/Github/Prindex/"
	}
	
/*******************************************************************************
	PART 3: Create document
*******************************************************************************/
		
		cd "${RT2}"
	
	if `document' {
	
		* Copy the Stata style to the same folder as the markdown file to compile in PDF
		//cd "${mdfolder}"
		//copy https://www.stata-journal.com/production/sjlatex/stata.sty 	stata.sty
		
		markstat using "PrindexAnalysis", docx
		*bundle using PrindexAnalysis
	
	}
	
*============================== THE END =======================================*
