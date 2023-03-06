xmlport 50026 "Production BOM Line"
{
    Caption = 'Production BOM Line';
    Direction = Import;
    FieldDelimiter = '"';
    FieldSeparator = ',';
    Format = VariableText;
    FormatEvaluate = Legacy;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement("Production BOM Line"; "Production BOM Line")
            {
                XmlName = 'ProductionBOMLine';
                AutoSave = false;
                textelement(I_BOMHeaderNo)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Index)
                {
                    MinOccurs = Zero;
                }
                textelement(I_UnitOfMeasure)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Postion)
                {
                    MinOccurs = Zero;
                }
                textelement(I_UnitOfMeasureItem)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Quantity)
                {
                    MinOccurs = Zero;
                }
                textelement(I_ItemNo)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Remark1)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Remark2)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Remark3)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Remark4)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Remark5)
                {
                    MinOccurs = Zero;
                }
                textelement(I_Remark6)
                {
                    MinOccurs = Zero;
                }

                trigger OnBeforeInsertRecord()
                begin
                end;

                trigger OnAfterInsertRecord()
                var
                    Item: Record Item;
                    BOMItem: Record Item;
                begin

                    Window.UPDATE(1, 'Import Production BOM');
                    Window.UPDATE(2, I_ItemNo);

                    Gbol_BaseError := FALSE;          //Flag of BOM Base unit of measure
                    Gbol_ItemBaseError := FALSE;      //Flag of Item Base unif of measure
                    Gblo_NewBOM := FALSE;             //Flag of New BOM
                    Gbol_NewItem := FALSE;            //Falg of New BOM Line  

                    //Index补零变成Bom Version
                    I_Index := DELCHR(I_Index, '=', ' ');
                    IF STRLEN(I_Index) = 0 THEN
                        Gcde_VersionCode := '000'
                    ELSE
                        IF STRLEN(I_Index) = 1 THEN
                            Gcde_VersionCode := '00' + I_Index
                        ELSE
                            IF STRLEN(I_Index) = 2 THEN
                                Gcde_VersionCode := '0' + I_Index
                            ELSE
                                IF STRLEN(I_Index) = 3 THEN
                                    Gcde_VersionCode := I_Index;

                    //==================================================================================
                    //Insert or Update BOM Header-------
                    Grcd_ProdBOMHeader.RESET;
                    IF NOT Grcd_ProdBOMHeader.GET(I_BOMHeaderNo) THEN BEGIN
                        Gblo_NewBOM := TRUE;
                        IF GetUnitOfMeasere(I_UnitOfMeasure) = 'ERROR' THEN
                            Gbol_BaseError := TRUE
                        ELSE
                            Grcd_ProdBOMHeader.INIT;
                        Grcd_ProdBOMHeader."No." := I_BOMHeaderNo;
                        Grcd_ProdBOMHeader.VALIDATE("No.", I_BOMHeaderNo);
                        Grcd_ProdBOMHeader."BOM Index" := Gcde_VersionCode;
                        Grcd_ProdBOMHeader."Unit of Measure Code" := GetUnitOfMeasere(I_UnitOfMeasure);
                        Grcd_ProdBOMHeader.Status := Grcd_ProdBOMHeader.Status::Certified; //Certify
                        Grcd_ProdBOMHeader."Creation Date" := WORKDATE;
                        Grcd_ProdBOMHeader."Last Date Modified" := WORKDATE;
                        Grcd_ProdBOMHeader."Created By Import" := TRUE;
                        Grcd_ProdBOMHeader.ImportFlag := TRUE;
                        //++ALF amend description
                        if Item.Get(Grcd_ProdBOMHeader."No.") then begin
                            Grcd_ProdBOMHeader.Description := Item.Description;
                            Grcd_ProdBOMHeader."Description 2" := item."Description 2";
                        end;
                        //--ALF
                        Grcd_ProdBOMHeader.INSERT;
                    END ELSE BEGIN
                        Grcd_ProdBOMHeader."BOM Index" := Gcde_VersionCode;
                        Grcd_ProdBOMHeader."Last Date Modified" := WORKDATE;
                        Grcd_ProdBOMHeader.ImportFlag := TRUE;
                        //++ALF amend description
                        if Item.Get(Grcd_ProdBOMHeader."No.") then begin
                            Grcd_ProdBOMHeader.Description := Item.Description;
                            Grcd_ProdBOMHeader."Description 2" := item."Description 2";
                        end;
                        //--ALF
                        Grcd_ProdBOMHeader.MODIFY;
                    END;
                    COMMIT;

                    //更新物料卡片的
                    Grcd_ItemUpdate.RESET;
                    IF Grcd_ItemUpdate.GET(Grcd_ProdBOMHeader."No.") THEN BEGIN
                        IF Grcd_ItemUpdate."Production BOM No." = '' THEN BEGIN
                            Grcd_ItemUpdate."Production BOM No." := I_BOMHeaderNo;
                            Grcd_ItemUpdate.MODIFY;
                        END;
                    END;

                    //=================================================================================================
                    //插入Production BOM Line
                    IF GetUnitOfMeasere(I_UnitOfMeasureItem) <> 'ERROR' THEN BEGIN
                        Grcd_ProdBOMLine.RESET;
                        Grcd_ProdBOMLine.SETRANGE("Production BOM No.", I_BOMHeaderNo);
                        Grcd_ProdBOMLine.SETRANGE("Version Code", Gcde_VersionCode);
                        //insert new BOM version
                        IF Grcd_ProdBOMLine.FIND('+') THEN begin
                            Gint_LastLineNo := Grcd_ProdBOMLine."Line No.";
                            Grcd_ProdBOMVersion.RESET;
                            Grcd_ProdBOMVersion.SETRANGE("Production BOM No.", I_BOMHeaderNo);
                            Grcd_ProdBOMVersion.SETRANGE("Version Code", Gcde_VersionCode);
                            IF Grcd_ProdBOMVersion.FIND('-') THEN BEGIN
                                Grcd_ItemUpdate.RESET;
                                IF Grcd_ItemUpdate.GET(I_BOMHeaderNo) THEN BEGIN
                                    Grcd_ProdBOMVersion.Description := Grcd_ItemUpdate.Description;
                                    Grcd_ProdBOMVersion."Unit of Measure Code" := Grcd_ItemUpdate."Base Unit of Measure";
                                END ELSE
                                    IF Grcd_ProdBOMHeader2.GET(I_BOMHeaderNo) THEN BEGIN
                                        Grcd_ProdBOMVersion.Description := Grcd_ProdBOMHeader2.Description;
                                        Grcd_ProdBOMVersion."Unit of Measure Code" := Grcd_ProdBOMHeader2."Unit of Measure Code";
                                    END;
                                Grcd_ProdBOMVersion.Status := Grcd_ProdBOMVersion.Status::Certified;
                                Grcd_ProdBOMVersion.Modify();
                            end;

                        end ELSE BEGIN
                            Grcd_ProdBOMVersion.RESET;
                            Grcd_ProdBOMVersion.SETRANGE("Production BOM No.", I_BOMHeaderNo);
                            Grcd_ProdBOMVersion.SETRANGE("Version Code", Gcde_VersionCode);
                            IF NOT Grcd_ProdBOMVersion.FIND('-') THEN BEGIN
                                Grcd_ProdBOMVersion.INIT;
                                Grcd_ProdBOMVersion."Production BOM No." := I_BOMHeaderNo;
                                Grcd_ProdBOMVersion."Version Code" := Gcde_VersionCode;
                                Grcd_ProdBOMHeader2.RESET;
                                Grcd_ItemUpdate.RESET;
                                IF Grcd_ItemUpdate.GET(I_BOMHeaderNo) THEN BEGIN
                                    Grcd_ProdBOMVersion.Description := Grcd_ItemUpdate.Description;
                                    Grcd_ProdBOMVersion."Unit of Measure Code" := Grcd_ItemUpdate."Base Unit of Measure";
                                END ELSE
                                    IF Grcd_ProdBOMHeader2.GET(I_BOMHeaderNo) THEN BEGIN
                                        Grcd_ProdBOMVersion.Description := Grcd_ProdBOMHeader2.Description;
                                        Grcd_ProdBOMVersion."Unit of Measure Code" := Grcd_ProdBOMHeader2."Unit of Measure Code";
                                    END;
                                Grcd_ProdBOMVersion."Starting Date" := WORKDATE;
                                Grcd_ProdBOMVersion."Last Date Modified" := WORKDATE;
                                Grcd_ProdBOMVersion.Status := Grcd_ProdBOMVersion.Status::Certified;
                                Grcd_ProdBOMVersion."Created By Import" := TRUE;
                                Grcd_ProdBOMVersion.INSERT;
                            END;
                            Gint_LastLineNo := 0;
                        END;
                        //insert new BOM version line
                        Grcd_ProdBOMLine.SETRANGE("No.", I_ItemNo);
                        Grcd_ProdBOMLine.SETRANGE(Position, I_Postion);
                        IF Grcd_ProdBOMLine.FIND('-') THEN BEGIN
                            Grcd_Item.RESET;
                            IF Grcd_Item.GET(I_ItemNo) THEN BEGIN
                                Grcd_ProdBOMLine.Description := Grcd_Item.Description;
                                IF Grcd_Item."Replenishment System" = Grcd_Item."Replenishment System"::Purchase THEN BEGIN
                                    Grcd_ProdBOMLine."Unit of Measure Code" := Grcd_Item."Base Unit of Measure";
                                    Grcd_ProdBOMLine.Type := Grcd_ProdBOMLine.Type::Item;
                                END;
                                IF Grcd_Item."Replenishment System" = Grcd_Item."Replenishment System"::"Prod. Order" THEN BEGIN
                                    Grcd_Item.get(I_ItemNo);
                                    //++ALF
                                    if Grcd_Item."Output Item" = true then
                                        Grcd_ProdBOMLine.Type := Grcd_ProdBOMLine.Type::Item
                                    else
                                        Grcd_ProdBOMLine.Type := Grcd_ProdBOMLine.Type::"Production BOM";
                                    //--ALF
                                    Grcd_ProdBOMLine."Unit of Measure Code" := GetUnitOfMeasere(I_UnitOfMeasureItem);
                                END;
                            END;
                            Evaluate(I_Quantity_Dec, I_Quantity);
                            Grcd_ProdBOMLine.VALIDATE(Grcd_ProdBOMLine."Quantity per", I_Quantity_Dec);
                            Grcd_ProdBOMLine.Position := I_Postion;
                            Grcd_ProdBOMLine.ImportFlag := TRUE;
                            Grcd_ProdBOMLine.MODIFY;
                        END ELSE BEGIN
                            Gbol_NewItem := TRUE;
                            Grcd_ProdBOMLine.INIT;
                            Grcd_ProdBOMLine."Production BOM No." := I_BOMHeaderNo;
                            Grcd_ProdBOMLine."Version Code" := Gcde_VersionCode;
                            Grcd_ProdBOMLine."Line No." := Gint_LastLineNo + 10000;
                            Grcd_Item.RESET;
                            IF Grcd_Item.GET(I_ItemNo) THEN BEGIN
                                Grcd_ProdBOMLine.Description := Grcd_Item.Description;
                                IF Grcd_Item."Replenishment System" = Grcd_Item."Replenishment System"::Purchase THEN BEGIN
                                    Grcd_ProdBOMLine."Unit of Measure Code" := Grcd_Item."Base Unit of Measure";
                                    Grcd_ProdBOMLine.Type := Grcd_ProdBOMLine.Type::Item;
                                END;
                                IF Grcd_Item."Replenishment System" = Grcd_Item."Replenishment System"::"Prod. Order" THEN BEGIN
                                    Grcd_Item.get(I_ItemNo);
                                    if Grcd_Item."Output Item" = true then
                                        Grcd_ProdBOMLine.Type := Grcd_ProdBOMLine.Type::Item
                                    else
                                        Grcd_ProdBOMLine.Type := Grcd_ProdBOMLine.Type::"Production BOM";
                                    Grcd_ProdBOMLine."Unit of Measure Code" := GetUnitOfMeasere(I_UnitOfMeasureItem);
                                END;
                            END ELSE BEGIN
                                Grcd_ProdBOMLine.Type := Grcd_ProdBOMLine.Type::Item;
                                Grcd_ProdBOMLine."Unit of Measure Code" := GetUnitOfMeasere(I_UnitOfMeasureItem);
                            END;
                            Grcd_ProdBOMLine."No." := I_ItemNo;
                            Evaluate(I_Quantity_Dec, I_Quantity);
                            Grcd_ProdBOMLine."Quantity per" := I_Quantity_Dec;
                            Grcd_ProdBOMLine.VALIDATE(Grcd_ProdBOMLine."Quantity per", I_Quantity_Dec);
                            Grcd_ProdBOMLine.Position := I_Postion;
                            Grcd_ProdBOMLine.ImportFlag := TRUE;
                            if Grcd_ProdBOMLine.Quantity <> 0 then
                                Grcd_ProdBOMLine.INSERT;
                        END;
                        //++ALF 将最后一个Version复制到当前BOM
                        Grcd_ProdBOMLine2.Init();
                        Grcd_ProdBOMLine2 := Grcd_ProdBOMLine;
                        Grcd_ProdBOMLine2."Version Code" := '';
                        Grcd_ProdBOMLine2.ImportFlag := true;
                        if Grcd_ProdBOMLine2.Quantity <> 0 then
                            IF not Grcd_ProdBOMLine2.Insert() then
                                Grcd_ProdBOMLine2.Modify();
                        //--ALF
                    END ELSE BEGIN
                        Grcd_ProdBOMLine.RESET;
                        Grcd_ProdBOMLine.SETRANGE("Production BOM No.", I_BOMHeaderNo);
                        Grcd_ProdBOMLine.SETRANGE("Version Code", Gcde_VersionCode);
                        Grcd_ProdBOMLine.SETRANGE("No.", I_ItemNo);
                        IF Grcd_ProdBOMLine.FIND('-') THEN BEGIN
                            Grcd_ProdBOMLine.ImportFlag := TRUE;
                            if Grcd_Item.get(I_ItemNo) then begin
                                //++Harvey221221
                                Grcd_ProdBOMLine.Description := Grcd_Item.Description;
                                IF Grcd_Item."Replenishment System" = Grcd_Item."Replenishment System"::Purchase THEN BEGIN
                                    Grcd_ProdBOMLine."Unit of Measure Code" := Grcd_Item."Base Unit of Measure";
                                    Grcd_ProdBOMLine.Type := Grcd_ProdBOMLine.Type::Item;
                                END;
                                IF Grcd_Item."Replenishment System" = Grcd_Item."Replenishment System"::"Prod. Order" THEN BEGIN
                                    Grcd_Item.get(I_ItemNo);
                                    if Grcd_Item."Output Item" = true then
                                        Grcd_ProdBOMLine.Type := Grcd_ProdBOMLine.Type::Item
                                    else
                                        Grcd_ProdBOMLine.Type := Grcd_ProdBOMLine.Type::"Production BOM";
                                    Grcd_ProdBOMLine."Unit of Measure Code" := GetUnitOfMeasere(I_UnitOfMeasureItem);
                                END;
                                //--Harvey
                                if Grcd_ProdBOMLine.Description = '' then
                                    Grcd_ProdBOMLine.Description := Grcd_Item.Description;
                            end;


                            Grcd_ProdBOMLine.MODIFY;
                        END;
                        Gbol_ItemBaseError := TRUE;
                    END;

                    IF Gbol_BaseError OR Gbol_ItemBaseError OR Gblo_NewBOM OR Gbol_NewItem THEN
                        BOMResultFunction(I_BOMHeaderNo, Gcde_VersionCode, I_ItemNo,
                                 Gint_LastLineNo, Gbol_BaseError, Gbol_ItemBaseError, Gblo_NewBOM, FALSE, Gbol_NewItem);
                    CurrXmlport.SKIP;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
    end;

    trigger OnPreXmlPort()
    begin
        Window.OPEN('Clearing #1##################');
        Grcd_ProdBOMHeadFlag.RESET;
        Grcd_ProdBOMHeadFlag.SetRange(ImportFlag, TRUE);
        if Grcd_ProdBOMHeadFlag.FindFirst() then
            repeat
                Window.Update(1, Grcd_ProdBOMHeadFlag."No.");
                Grcd_ProdBOMHeadFlag.ImportFlag := false;
                Grcd_ProdBOMHeadFlag.Modify();
            until Grcd_ProdBOMHeadFlag.Next() = 0;
        //Grcd_ProdBOMHeadFlag.MODIFYALL(Grcd_ProdBOMHeadFlag.ImportFlag, FALSE);
        Grcd_ProdBOMLineFlag.RESET;
        Grcd_ProdBOMLineFlag.SetRange(ImportFlag, TRUE);
        if Grcd_ProdBOMLineFlag.FindFirst() then
            repeat
                Window.Update(1, Grcd_ProdBOMLineFlag."Production BOM No.");
                Grcd_ProdBOMLineFlag.ImportFlag := false;
                Grcd_ProdBOMLineFlag.Modify();
            until Grcd_ProdBOMLineFlag.Next() = 0;
        //Grcd_ProdBOMLineFlag.MODIFYALL(Grcd_ProdBOMLineFlag.ImportFlag, FALSE);
        Window.Close();

        Window.OPEN('Process #1################## \' +
                    'Item No.#2##################');
    end;

    trigger OnPostXmlPort()
    var
        Item: Record Item;
        BOMLine: Record "Prod. Order Line";
    begin
        Grcd_ProdBOMHeadFlag.RESET;
        Grcd_ProdBOMHeadFlag.SETRANGE(Grcd_ProdBOMHeadFlag.ImportFlag, TRUE);
        IF Grcd_ProdBOMHeadFlag.FIND('-') THEN
            REPEAT
                Grcd_ProdLineFlag.RESET;
                Grcd_ProdLineFlag.SETRANGE("Production BOM No.", Grcd_ProdBOMHeadFlag."No.");
                Grcd_ProdLineFlag.SETRANGE("Version Code", Grcd_ProdBOMHeadFlag."BOM Index");
                Grcd_ProdLineFlag.SETRANGE(ImportFlag, TRUE);
                IF Grcd_ProdLineFlag.FIND('-') THEN BEGIN
                    Grcd_ProdBOMLineFlag.RESET;
                    Grcd_ProdBOMLineFlag.SETRANGE("Production BOM No.", Grcd_ProdBOMHeadFlag."No.");
                    Grcd_ProdBOMLineFlag.SETRANGE("Version Code", Grcd_ProdBOMHeadFlag."BOM Index");
                    Grcd_ProdBOMLineFlag.SETRANGE(ImportFlag, FALSE);
                    IF Grcd_ProdBOMLineFlag.FIND('-') THEN
                        REPEAT
                            Window.UPDATE(1, 'Delete useless BOM Line');
                            Window.UPDATE(2, Grcd_ProdBOMLineFlag."No.");
                            BOMResultFunction(Grcd_ProdBOMLineFlag."Production BOM No.", Grcd_ProdBOMLineFlag."Version Code",
                                  Grcd_ProdBOMLineFlag."No.", Grcd_ProdBOMLineFlag."Line No.", FALSE, FALSE, FALSE, TRUE, FALSE);
                            Grcd_ProdBOMLineFlag.DELETE;
                        UNTIL Grcd_ProdBOMLineFlag.NEXT = 0;
                    //++ALF 不带Version的BOM行多余数据删除
                    Grcd_ProdBOMLineFlag.RESET;
                    Grcd_ProdBOMLineFlag.SETRANGE("Production BOM No.", Grcd_ProdBOMHeadFlag."No.");
                    Grcd_ProdBOMLineFlag.SETRANGE("Version Code", '');
                    Grcd_ProdBOMLineFlag.SETRANGE(ImportFlag, FALSE);
                    IF Grcd_ProdBOMLineFlag.FIND('-') THEN
                        REPEAT
                            Window.UPDATE(1, 'Delete useless BOM Line');
                            Window.UPDATE(2, Grcd_ProdBOMLineFlag."No.");
                            BOMResultFunction(Grcd_ProdBOMLineFlag."Production BOM No.", Grcd_ProdBOMLineFlag."Version Code",
                                  Grcd_ProdBOMLineFlag."No.", Grcd_ProdBOMLineFlag."Line No.", FALSE, FALSE, FALSE, TRUE, FALSE);
                            Grcd_ProdBOMLineFlag.DELETE;
                        UNTIL Grcd_ProdBOMLineFlag.NEXT = 0;
                    //--ALF
                END;
            UNTIL Grcd_ProdBOMHeadFlag.NEXT = 0;

        Lrcd_BOMHeader.RESET;
        IF Lrcd_BOMHeader.FIND('-') THEN
            REPEAT
                Window.UPDATE(1, 'Refresh Active Version');
                Window.UPDATE(2, Lrcd_BOMHeader."No.");
                Lcde_ActiveVersion := '';
                Lcde_ActiveVersion := VersionMgt.GetBOMVersion(Lrcd_BOMHeader."No.", WORKDATE, TRUE);
                IF Lcde_ActiveVersion <> Lrcd_BOMHeader."Active Version" THEN BEGIN
                    Lrcd_BOMHeader."Active Version" := Lcde_ActiveVersion;
                    Lrcd_BOMHeader.MODIFY;
                END;
            UNTIL Lrcd_BOMHeader.NEXT = 0;

        Window.CLOSE;

        //++Harvey221128 刷新BOM行的物料描述
        Grcd_ProdBOMLine2.Reset();
        Grcd_ProdBOMLine2.SetRange(Description, '');
        Grcd_ProdBOMLine2.SetRange(Type, Grcd_ProdBOMLine2.Type::Item);
        if Grcd_ProdBOMLine2.FindFirst() then
            repeat
                if Item.get(Grcd_ProdBOMLine2."No.") then begin
                    Grcd_ProdBOMLine.Description := Grcd_Item.Description;
                    Grcd_ProdBOMLine2.Description := Item.Description;
                    Grcd_ProdBOMLine2.Modify();
                end;
            until Grcd_ProdBOMLine2.Next() = 0;
        //--Harvey221128

        Window.OPEN('Process #1################## \' +
                    'Item No.#2##################');
        //++Harvey221128 根据Output item刷新BOM行的Type
        Grcd_ProdBOMLine2.Reset();
        Grcd_ProdBOMLine2.SetFilter("Production BOM No.", '<>%1', 'T*');
        if Grcd_ProdBOMLine2.FindFirst() then
            repeat
                Window.UPDATE(1, 'Refresh Output Item');
                Window.UPDATE(2, Grcd_ProdBOMLine2."Production BOM No.");
                if Grcd_Item.get(Grcd_ProdBOMLine2."No.") then begin
                    IF Grcd_Item."Replenishment System" = Grcd_Item."Replenishment System"::"Prod. Order" THEN BEGIN
                        if Grcd_Item."Output Item" = true then
                            Grcd_ProdBOMLine2.Type := Grcd_ProdBOMLine2.Type::Item
                        else
                            Grcd_ProdBOMLine2.Type := Grcd_ProdBOMLine2.Type::"Production BOM";
                        Grcd_ProdBOMLine2.Modify();
                    END;
                end;
            until Grcd_ProdBOMLine2.Next() = 0;
        //--Harvey221128

    end;

    procedure GetUnitOfMeasere(P_Des: Code[10]) R_BUM: Code[10]
    begin
        R_BUM := '';
        IF UPPERCASE(P_Des) = 'ST' THEN
            R_BUM := 'PCS'
        ELSE
            IF UPPERCASE(P_Des) = 'M' THEN
                R_BUM := 'M'
            ELSE
                IF UPPERCASE(P_Des) = 'MM' THEN
                    R_BUM := 'MM'
                ELSE
                    IF UPPERCASE(P_Des) = 'KG' THEN
                        R_BUM := 'KG'
                    ELSE
                        IF UPPERCASE(P_Des) = 'G' THEN
                            R_BUM := 'G'
                        ELSE
                            IF UPPERCASE(P_Des) = 'T' THEN
                                R_BUM := 'T'
                            ELSE
                                IF UPPERCASE(P_Des) = 'L' THEN
                                    R_BUM := 'L'
                                ELSE
                                    IF UPPERCASE(P_Des) = 'P' THEN
                                        R_BUM := 'P'
                                    ELSE
                                        IF UPPERCASE(P_Des) = 'ML' THEN
                                            R_BUM := 'ML'
                                        ELSE
                                            IF UPPERCASE(P_Des) = 'SET' THEN
                                                R_BUM := 'S'
                                            ELSE
                                                IF UPPERCASE(P_Des) = 'M2' THEN
                                                    R_BUM := 'M2'
                                                ELSE
                                                    IF UPPERCASE(P_Des) = 'CM2' THEN
                                                        R_BUM := 'CM2'

                                                    ELSE
                                                        R_BUM := 'ERROR';
    end;


    procedure BOMResultFunction(P_BOMNo: Code[20]; P_VersionCode: Code[20]; P_ItemNo: Code[20]; P_Line: Integer; P_BaseError: Boolean; P_ItemBaseError: Boolean; P_NewBom: Boolean; P_Delete: Boolean; P_Insert: Boolean);
    VAR
        Lrcd_BOMResult: Record "BOM PLM To Nav Result";
        Lrcd_BOMLine: Record "Production BOM Line";
        Lint_EntryNo: Integer;
    begin

        Window.UPDATE(1, 'Record Import Process');
        Window.UPDATE(2, P_ItemNo);

        Lrcd_BOMResult.RESET;
        IF Lrcd_BOMResult.FIND('+') THEN
            Lint_EntryNo := Lrcd_BOMResult."Entry No" + 1
        ELSE
            Lint_EntryNo := 1;

        Lrcd_BOMResult.INIT;
        Lrcd_BOMResult."Entry No" := Lint_EntryNo;
        Lrcd_BOMResult."Production BOM No." := P_BOMNo;
        Lrcd_BOMResult."Line No." := P_Line;
        Lrcd_BOMResult."Version Code" := P_VersionCode;
        Lrcd_BOMResult."Item No" := P_ItemNo;
        Lrcd_BOMLine.RESET;
        IF Lrcd_BOMLine.GET(P_BOMNo, P_VersionCode, P_Line) THEN BEGIN
            Lrcd_BOMResult.Type := Lrcd_BOMLine.Type;
            Lrcd_BOMResult.Description := Lrcd_BOMLine.Description;
            Lrcd_BOMResult."Unit of Measure Code" := Lrcd_BOMLine."Unit of Measure Code";
            Lrcd_BOMResult.Quantity := Lrcd_BOMLine.Quantity;
            Lrcd_BOMResult.Position := Lrcd_BOMLine.Position;
        END;
        Lrcd_BOMResult."BOM Base Error" := P_BaseError;
        Lrcd_BOMResult."Item Base Error" := P_ItemBaseError;
        Lrcd_BOMResult."New BOM" := P_NewBom;
        Lrcd_BOMResult.Deleted := P_Delete;
        Lrcd_BOMResult.Inserted := P_Insert;
        Lrcd_BOMResult."Create Date" := TODAY;
        Lrcd_BOMResult."Create Time" := TIME;
        Lrcd_BOMResult."User ID" := USERID;
        Lrcd_BOMResult.INSERT;
    end;

    VAR
        Window: Dialog;
        Grcd_ProdBOMHeadFlag: Record "Production BOM Header";
        Lrcd_BOMHeader: Record "Production BOM Header";
        Grcd_ProdLineFlag: Record "Production BOM Line";
        Grcd_ProdBOMLineFlag: Record "Production BOM Line";
        Grcd_ProdBOMHeader: Record "Production BOM Header";
        Grcd_ProdBOMHeader2: Record "Production BOM Header";
        Grcd_ProdBOMLine: Record "Production BOM Line";
        //++Harvey1102
        Grcd_ProdBOMLine2: Record "Production BOM Line";
        //--Harvey1102
        Grcd_ProdBOMVersion: Record "Production BOM Version";
        Grcd_ItemUpdate: Record Item;
        Grcd_Item: Record Item;
        Gcde_VersionCode: Code[10];
        Gbol_BaseError: Boolean;
        Gbol_ItemBaseError: Boolean;
        Gblo_NewBOM: Boolean;
        Gbol_NewItem: Boolean;
        Gint_LastLineNo: Integer;
        I_Quantity_Dec: Decimal;
        Lcde_ActiveVersion: Code[20];
        VersionMgt: Codeunit "VersionManagement";
}
