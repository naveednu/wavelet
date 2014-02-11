###Discrete wavelet transform
=======
####Usage 
`image = imread('tom.png');`

`[coefficients, images] = wavelet(image, 1, 1);`

`figure;`

`imshow(coefficients);`

`figure;`

`imshow(images);`
