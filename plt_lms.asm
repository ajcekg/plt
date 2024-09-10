	opt h+
	org $80
	
	icl "atari.hea"

	value = $60
	delta = $62
	t1 = $64
	t2 = $35
	t3 = start
	
	x1 = start
	y1 = start+1

	


	mem = $1000
	sine = mem  + $100
	dl	 = $4141+7	;sine + $200
	px	 = sine + $200
	pxb	 = px + $100
	yh	 = pxb+$100
	yl	 = yh+$100
	ch   = yl+$100
	cl   = ch+$100
	scr  = $3000
	
start

	ldx #0
	stx nmien
	ldy #%00100001
	sty dmactl

; clear mem, gen dl, calc tab
	ldy #63
k	lda #0
l	sta mem,x
	sta $80-63,y
	lda #$70
	sta dl-$100,x
	lda #$f
	sta dl,x
	txa
	lsr
	lsr
	lsr
	sta px,x

m0	lda #0
	sta yl,x
	clc
	adc #32
	sta m0+1
m1	lda #$50
	sta yh,x
	adc #0
	sta m1+1 

	txs
	txa
	and #$7
	tax
	lda t,x
	tsx
	sta pxb,x

	inx
	bne k
	inc l+2
	dey
	bpl k	

	lda #$4f
	sta dl
	lda #>scr
	sta dl+2
	stx dl+1
	lda #$41
	sta colpf2
	sta colbak
	sta dl+130
	sta dl+132
	sta dlptr+1
	sta dl+131
	sta dlptr

; calculate sin tab
	ldy #$3f
l0	lda value
	adc delta
	sta value
	lda value+1
	adc delta+1
	sta value+1
	sta sine+$c0,x
	sta sine+$80,y
	eor #$ff
	sta sine+$40,x
	sta sine+$00,y
	lda delta
	adc #$10 
	sta delta
	bcc l1
	inc delta+1
l1  inx
	dey
	bpl l0
 
	
main_loop	
	dec y1
	dec x1
q1	tsx
	lda ch,x
	sta qm+2
	lda cl,x
	sta qm+1
	lda #0
qm	sta 1000

	ldx y1
	lda sine,x
	lsr
	tay
	lda yh,y
	sta t2
	lda yl,y
	sta t1
	
	ldx x1
	lda sine,x
	tay
	lda px,y
	clc
	adc t1
	tsx
	sta cl,x
	sta p0+1
	lda t2
	adc #0
	sta p0+2
	sta ch,x
	lda pxb,y
p0	sta 1000
	inc y1
	dec x1
	dec x1
	dec x1
	inx
	txs
	bne q1
	beq main_loop
 
t dta b (128,64,32,16,8,4,2,1)
