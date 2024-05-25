function T = readpose(filename)

fileID = fopen(filename);
cell_array = textscan(fileID, '%s', 'delimiter', '\n');
fclose(fileID);

p =  {'Translation','Rotation: in Quaternion'};
for i = 1:2
    r = p{i};
    ind = ~cellfun(@isempty,regexp(cell_array{1},r));
    str = regexp(cell_array{1}(ind), '\[.*\]','match');
    datacell = cellfun(@(x) eval(x{1}),str,'UniformOutput',false);
    if i == 1
        T.tran = cell2mat(datacell);
    else
        rot = cell2mat(datacell);
        T.rot = [rot(:,4),rot(:,1:3)];
    end
end

T.size = min([size(T.rot,1),size(T.tran,1)]);
if size(T.rot,1)~=size(T.tran,1)
    T.rot = T.rot(1:T.size,:);
    T.tran = T.tran(1:T.size,:);
    warning('Number of Translation and Rotation doesn''t Match')
end

end