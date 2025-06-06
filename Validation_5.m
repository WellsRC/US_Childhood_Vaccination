clear;
clc;
parpool(24)

Spatial_Validation=1;
Vac={'MMR','DTaP','POLIO','VAR'};

for vv=3:4
    for Time_Validation_Set=1:3
        Spatial_Temporal_K_Fold_Validation(Vac{vv},Spatial_Validation,Time_Validation_Set);
    end
end