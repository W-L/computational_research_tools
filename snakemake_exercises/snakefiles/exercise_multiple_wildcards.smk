rule first_step:
    output:
        'data/?.txt'
    shell:
        'echo "this is data of ? with treatment ?" > {output}'

rule second_step:
    input:
        rules.first_step.output
    output:
        'results/?.txt'
    shell:
        'cp {input} {output}'


