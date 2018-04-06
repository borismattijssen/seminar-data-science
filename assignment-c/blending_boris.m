clear
% target image
image=imread('target.jpg');
[h_target w_target d_target]=size(image);
U = double(reshape(image,w_target*h_target,d_target))/255;

% source image
image_source=imread('source.jpg');
[h_source w_source d_source]=size(image_source);
U_source = double(reshape(image_source,w_source*h_source,d_source))/255;

% extended (padded) source image
extended = padarray(image_source, [1 1], 0);
[h_extended w_extended d_extended]=size(extended);
U_extended = double(reshape(extended,w_extended*h_extended,d_extended))/255;

figure, imshow(extended);

%% Create target box, later used to extract U_b
% position of source in target image;
x = 5;
y = 220;

% xy ranges in target image
target_x_from = x - 1;
target_x_to = x + w_source;
target_y_from = y - 1;
target_y_to = y + h_source;

% create U vector containing all pixels from the target in size of the
% source + 2
targetbox = image(target_y_from:target_y_to, target_x_from:target_x_to,:);
[h_targetbox w_targetbox d_targetbox]=size(targetbox);
U_targetbox = double(reshape(targetbox,w_targetbox*h_targetbox,d_targetbox))/255;
figure, imshow(targetbox);

%% Optimize
a = 5;

%inner and boundary gradients only
G = gradient(h_extended, w_extended);

%selector matrix, boundary pixels only
S = selmat_square(w_extended, h_extended);

%gradients of source image
g = G * U_extended;

%set boundary gradients to zero
g = boundary_gradients_zero(g, w_extended, h_extended);

% make vector of boundary pixels
U_b = S * U_targetbox;

% linear system
leftside =  G' * G + a *  (S'*S);
rightside = G'*g + a*S'*U_b;
U_blended = leftside\rightside;

% blended image
image_blended =uint8(reshape(U_blended,h_extended,w_extended,d_source)*255);
figure, imshow(image_blended)

% blended image pasted in the target image
image_final = image;
image_final(y:y+h_extended-1,x:x+w_extended-1,:) = image_blended;
figure, imshow(image_final)