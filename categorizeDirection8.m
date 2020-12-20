function bin = categorizeDirection8(Direction)
    if Direction <= 22.5 && Direction > -22.5
        bin = 1;
    elseif Direction <= 67.5 && Direction > 22.5
        bin = 2;
    elseif Direction <= 112.5 && Direction > 67.5
        bin = 3;
    elseif Direction <= 157.5 && Direction > 112.5
        bin = 4;
    elseif Direction <= -157.5 || Direction > 157.5
        bin = 5;
    elseif Direction <= -112.5 && Direction > -157.5
        bin = 6;
    elseif Direction <= -67.5 && Direction > -112.5
        bin = 7;
    elseif Direction <= -22.5 && Direction > -67.5
        bin = 8;
    end
end