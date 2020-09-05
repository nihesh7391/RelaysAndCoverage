%img = imread('iisc_try1.jpg');
function reconstructed_image = ImagePreProcess_5regions(img)

% Filtering Open Area
[bw1, ~] = Mask_OA_pink(img);
figure;
subplot(1,5,1);
imshow(bw1);title('OA');
openarea_block_image = bw1 * 10;

% Filtering Buildings
[bw2, ~] = Mask_building_orange(img);
%figure;
subplot(1,5,2);
imshow(bw2); title('Buildings');
building_block_image = bw2 * 30;

% Filtering Roads
[bw3, ~] = Mask_roads_gray(img);
%figure;
subplot(1,5,3);
imshow(bw3);title('Roads');
roads_block_image = bw3 * 20;

% Filtering Heavy Woods
[bw4, ~] = Mask_Hwoods_green(img);
%figure;
subplot(1,5,4);imshow(bw4);title('Hwoods ');
Hwoods_block_image = bw4 * 50;

% Getting background
%bw5  = bw1 | bw2 | bw3 | bw4;bw5 = ~bw5;Mwoods_block_image = bw5*40;

Mwoods_block_image = (~(bw1 | bw2 | bw3 | bw4)) * 40;
bw5 = ~(bw1 | bw2 | bw3 | bw4);
subplot(1,5,5) ;imshow(bw5);title('Mwoods');
reconstructed_image = openarea_block_image + building_block_image + roads_block_image + Hwoods_block_image + Mwoods_block_image;
%imshow(reconstructed_image);

end

% 
% %img = imread('iisc_try1.jpg');
% function reconstructed_image = ImagePreProcess_5regions(img)
% 
% % Filtering Open Area
% [bw1, ~] = Mask_OA_pink(img);
% figure;
% subplot(1,5,1);
% imshow(bw1);title('OA');
% openarea_block_image = bw1 * 10;
% 
% % Filtering Buildings
% [bw2, ~] = Mask_building_orange(img);
% %figure;
% subplot(1,5,2);
% imshow(bw2); title('Buildings');
% building_block_image = bw2 * 30;
% 
% % Filtering Roads
% [bw3, ~] = Mask_roads_gray(img);
% %figure;
% subplot(1,5,3);
% imshow(bw3);title('Roads');
% roads_block_image = bw3 * 20;
% 
% % Filtering Heavy Woods
% [bw4, ~] = Mask_Hwoods_green(img);
% %figure;
% subplot(1,5,4);imshow(bw4);title('Hwoods ');
% Hwoods_block_image = bw4 * 50;
% 
% % Getting background
% %bw5  = bw1 | bw2 | bw3 | bw4;bw5 = ~bw5;Mwoods_block_image = bw5*40;
% 
% Mwoods_block_image = (~(bw1 | bw2 | bw3 | bw4)) * 40;
% bw5 = ~(bw1 | bw2 | bw3 | bw4);
% subplot(1,5,5) ;imshow(bw5);title('Mwoods');
% reconstructed_image = openarea_block_image + building_block_image + roads_block_image + Hwoods_block_image + Mwoods_block_image;
% %imshow(reconstructed_image);
% 
% end