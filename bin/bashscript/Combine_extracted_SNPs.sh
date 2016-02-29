#!/bin/bash
#
# Script to run jSNPmania
#SBATCH -p devcore -n 1
#SBATCH -t 15:00

# Include functions
. $SERA_PATH/includes/logging.sh;

SuccessLog $SAMPLEID "Starts combining extracted info about SNPs ...";

# Check if the directory exists, if not create it
if [ ! -d $ROOT_PATH/Extracted_SNPs ]; then 
	mkdir $ROOT_PATH/Extracted_SNPs;
fi 

if [ ${READS} == "true" ]; then
	if [ ${CALL_TYPE} == "h.sapiens" ]; then

		# Ampliconmapped
		# Check if a combined file exist, then remove it
		if [ -e $ROOT_PATH/Extracted_SNPs/SNPs.allSamples.ampliconmapped.txt ]; then
			rm $ROOT_PATH/Extracted_SNPs/SNPs.allSamples.ampliconmapped.txt;
		fi
		# If there still exist input files - create combined file
		ls -1 $ROOT_PATH/Extracted_sampleInfo/*_SNPs.ampliconmapped.txt > /dev/null 2>&1
		if [  "$?" = "0" ]; then
			awk 'BEGIN{print "#Run\tSample\tTumour\tVaf\tRef_RD\tVar_RD\tTot_RD\t#Ref_amp\t#Var_amp\tChr\tPos\tRef\tVar\tId\tRef_amp\tVar_amp"} {if($1!~/#Run/){print $0}}' $ROOT_PATH/Extracted_sampleInfo/*_SNPs.ampliconmapped.txt > $ROOT_PATH/Extracted_SNPs/SNPs.allSamples.ampliconmapped.txt;
			
		else
			ErrorLog "$SAMPLEID" "No files with ending *_SNPs.ampliconmapped.txt were found!";
		fi

		# Without ampliconmapping
		# Check if a combined file exist, then remove it
		if [ -e $ROOT_PATH/Extracted_SNPs/SNPs.allSamples.txt ]; then
			rm $ROOT_PATH/Extracted_SNPs/SNPs.allSamples.txt;
		fi
		# If there still exist input files - create combined file
		ls -1 $ROOT_PATH/Extracted_sampleInfo/*_SNPs.txt > /dev/null 2>&1
		if [  "$?" = "0" ]; then
			awk 'BEGIN{print "#Run\tSample\tTumour\tVaf\tRef_RD\tVar_RD\tTot_RD\t#Ref_amp\t#Var_amp\tChr\tPos\tRef\tVar\tId\tRef_amp\tVar_amp"} {if($1!~/#Run/){print $0}}' $ROOT_PATH/Extracted_sampleInfo/*_SNPs.txt > $ROOT_PATH/Extracted_SNPs/SNPs.allSamples.txt;
			
		else
			ErrorLog "$SAMPLEID" "No files with ending *_SNPs.txt were found!";
		fi
	else
		ErrorLog "$SAMPLEID" "Only supported for h.sapiens so far!";
	fi
else
	ErrorLog "$SAMPLEID" "READS has to be true for the analysis to run!";
fi

if [ "$?" != "0" ]; then
	ErrorLog "$SAMPLEID" "Failed in combining SNP extracted info";
else
	SuccessLog "$SAMPLEID" "Passed combining SNP extracted info";
fi