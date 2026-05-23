#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
 * Define the FastQC Process
 * This pulls the official FastQC software using Docker
 */
process FASTQC {
    tag "QC on $reads"
    publishDir "${params.outdir}/fastqc", mode: 'copy'
    container 'quay.io/biocontainers/fastqc:0.11.9--0'

    input:
    path reads

    output:
    path "*_fastqc.{zip,html}"

    script:
    """
    fastqc -q $reads
    """
}

/*
 * Define the Main Workflow
 */
workflow {
    reads_ch = Channel.fromPath(params.reads, checkIfExists: true)
    FASTQC(reads_ch)
}
