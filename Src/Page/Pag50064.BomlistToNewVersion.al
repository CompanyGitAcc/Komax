page 50064 BomlistToNewVersion
{
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Production BOM Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Production BOM No."; Rec."Production BOM No.")
                {
                }
                field("Version Code"; Rec."Version Code")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field("Scrap %"; Rec."Scrap %")
                {
                }
                field(Certify; Rec.Certify)
                {
                }
                field("Quantity Used"; Rec."Quantity Used")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create A New Production BOM")
            {
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TEXT001: Label 'The Version you want to create has been exist,Do you want to Record it? Yes / No';
                begin

                    Gcde_NewVersion := FORMAT(Gcde_SalesNo) + '-' + FORMAT(Gint_SalesLine + 1);
                    Grcd_ProBOMLine.RESET;
                    Grcd_ProBOMLine.SETRANGE("Production BOM No.", Rec."Production BOM No.");
                    Grcd_ProBOMLine.SETRANGE("Version Code", Gcde_NewVersion);
                    IF NOT Grcd_ProBOMLine.FIND('-') THEN BEGIN
                        Gint_LineNo := 0;
                        //--Insert Rec To Temp Production BOM Line table
                        Temp_BOMLine.RESET;
                        Temp_BOMLine.DELETEALL;
                        Rec.FIND('-');
                        REPEAT
                            Temp_BOMLine.INIT;
                            Temp_BOMLine."Production BOM No." := Rec."Production BOM No.";
                            Temp_BOMLine."Version Code" := Rec."Version Code";
                            Temp_BOMLine."Line No." := Rec."Line No.";
                            Temp_BOMLine.Type := Rec.Type;
                            Temp_BOMLine."No." := Rec."No.";
                            Temp_BOMLine.Description := Rec.Description;
                            Temp_BOMLine."Unit of Measure Code" := Rec."Unit of Measure Code";
                            Temp_BOMLine.Quantity := Rec."Quantity Used";  //******
                            Temp_BOMLine.Position := Rec.Position;
                            Temp_BOMLine."Position 2" := Rec."Position 2";
                            Temp_BOMLine."Position 3" := Rec."Position 3";
                            Temp_BOMLine."Production Lead Time" := Rec."Production Lead Time";
                            Temp_BOMLine."Routing Link Code" := Rec."Routing Link Code";
                            Temp_BOMLine."Scrap %" := Rec."Scrap %";
                            Temp_BOMLine."Variant Code" := Rec."Variant Code";
                            Temp_BOMLine."Starting Date" := Rec."Starting Date";
                            Temp_BOMLine."Ending Date" := Rec."Ending Date";
                            Temp_BOMLine.Length := Rec.Length;
                            // Temp_BOMLine.Width := WIDTH;
                            Temp_BOMLine.Weight := Rec.Weight;
                            Temp_BOMLine.Depth := Rec.Depth;
                            Temp_BOMLine."Calculation Formula" := Rec."Calculation Formula";
                            Temp_BOMLine."Quantity per" := Rec."Quantity Used";  //******
                            Temp_BOMLine.Certify := Rec.Certify;
                            Temp_BOMLine.Comment := Rec.Comment;
                            Temp_BOMLine.INSERT;
                        UNTIL Rec.NEXT = 0;

                        COMMIT;
                        //++
                        Temp_BOMLine.RESET;
                        IF Temp_BOMLine.FIND('-') THEN
                            ;
                        Temp_BOMLine.RESET;
                        Temp_BOMLine.SETFILTER(Temp_BOMLine."No.", '<>%1', '');
                        Temp_BOMLine.SETRANGE(Temp_BOMLine.Certify, TRUE);
                        IF Temp_BOMLine.FIND('-') THEN BEGIN
                            Grcd_ProBomVer.RESET;
                            Grcd_ProBomVer.SETRANGE(Grcd_ProBomVer."Production BOM No.", Rec."Production BOM No.");
                            Grcd_ProBomVer.SETRANGE(Grcd_ProBomVer."Version Code", Gcde_NewVersion);
                            IF NOT Grcd_ProBomVer.FIND('-') THEN BEGIN
                                Grcd_ProBomVer.INIT;
                                Grcd_ProBomVer."Production BOM No." := Temp_BOMLine."Production BOM No.";
                                Grcd_ProBomVer."Version Code" := Gcde_NewVersion;
                                //   FORMAT(Gcde_SalesNo) + FORMAT(Gcdu_NoSerMage.GetNextNo(Grcd_NoSeries.Code,TODAY,TRUE));
                                Grcd_ProBomVer."Starting Date" := WORKDATE;
                                Grcd_ProBOMHeader.RESET;
                                Grcd_ProBOMHeader.SETRANGE(Grcd_ProBOMHeader."No.", Rec."Production BOM No.");
                                IF Grcd_ProBOMHeader.FINDSET THEN BEGIN
                                    Grcd_ProBomVer.Description := Grcd_ProBOMHeader.Description;
                                    Grcd_ProBomVer."Unit of Measure Code" := Grcd_ProBOMHeader."Unit of Measure Code";
                                END;
                                Grcd_ProBomVer."Last Date Modified" := WORKDATE;
                                Grcd_ProBomVer.Status := Grcd_ProBomVer.Status::New;
                                Grcd_ProBomVer.INSERT;
                            END;
                        END;

                        Temp_BOMLine.RESET;
                        IF Temp_BOMLine.FIND('-') THEN
                            ;

                        Temp_BOMLine.RESET;
                        Temp_BOMLine.SETFILTER(Temp_BOMLine."No.", '<>%1', '');
                        Temp_BOMLine.SETRANGE(Temp_BOMLine.Certify, TRUE);
                        IF Temp_BOMLine.FIND('-') THEN
                            REPEAT
                                Grcd_ProBOMLine.INIT;
                                Gint_LineNo += 10000;
                                Grcd_ProBOMLine."Production BOM No." := Temp_BOMLine."Production BOM No.";
                                Grcd_ProBOMLine."Version Code" := Gcde_NewVersion;
                                Grcd_ProBOMLine."Line No." := Gint_LineNo;
                                Grcd_ProBOMLine.Type := Temp_BOMLine.Type;
                                Grcd_ProBOMLine."No." := Temp_BOMLine."No.";
                                Grcd_ProBOMLine.Description := Temp_BOMLine.Description;
                                Grcd_ProBOMLine."Unit of Measure Code" := Temp_BOMLine."Unit of Measure Code";
                                Grcd_ProBOMLine.Quantity := Temp_BOMLine.Quantity;
                                Grcd_ProBOMLine.Position := Temp_BOMLine.Position;
                                Grcd_ProBOMLine."Position 2" := Temp_BOMLine."Position 2";
                                Grcd_ProBOMLine."Position 3" := Temp_BOMLine."Position 3";
                                Grcd_ProBOMLine."Production Lead Time" := Temp_BOMLine."Production Lead Time";
                                Grcd_ProBOMLine."Routing Link Code" := Temp_BOMLine."Routing Link Code";
                                Grcd_ProBOMLine."Scrap %" := Temp_BOMLine."Scrap %";
                                Grcd_ProBOMLine."Variant Code" := Temp_BOMLine."Variant Code";
                                Grcd_ProBOMLine."Starting Date" := Temp_BOMLine."Starting Date";
                                Grcd_ProBOMLine."Ending Date" := Temp_BOMLine."Ending Date";
                                Grcd_ProBOMLine.Length := Temp_BOMLine.Length;
                                Grcd_ProBOMLine.Width := Temp_BOMLine.Width;
                                Grcd_ProBOMLine.Weight := Temp_BOMLine.Weight;
                                Grcd_ProBOMLine.Depth := Temp_BOMLine.Depth;
                                Grcd_ProBOMLine."Calculation Formula" := Temp_BOMLine."Calculation Formula";
                                Grcd_ProBOMLine."Quantity per" := Temp_BOMLine."Quantity per";
                                Grcd_ProBOMLine.Certify := Temp_BOMLine.Certify;
                                Grcd_ProBOMLine.Comment := Temp_BOMLine.Comment;
                                Grcd_ProBOMLine.INSERT;
                            UNTIL Temp_BOMLine.NEXT = 0;
                        MESSAGE('Create BOM Version Sucessed');
                    END
                    ELSE
                        IF CONFIRM(TEXT001) THEN BEGIN

                            Gint_LineNo := 0;
                            //--Insert Rec To Temp Production BOM Line table
                            Temp_BOMLine.RESET;
                            Temp_BOMLine.DELETEALL;
                            Rec.FIND('-');
                            REPEAT
                                Temp_BOMLine.INIT;
                                Temp_BOMLine."Production BOM No." := Rec."Production BOM No.";
                                Temp_BOMLine."Version Code" := Rec."Version Code";
                                Temp_BOMLine."Line No." := Rec."Line No.";
                                Temp_BOMLine.Type := Rec.Type;
                                Temp_BOMLine."No." := Rec."No.";
                                Temp_BOMLine.Description := Rec.Description;
                                Temp_BOMLine."Unit of Measure Code" := Rec."Unit of Measure Code";
                                Temp_BOMLine.Quantity := Rec."Quantity Used"; //****
                                Temp_BOMLine.Position := Rec.Position;
                                Temp_BOMLine."Position 2" := Rec."Position 2";
                                Temp_BOMLine."Position 3" := Rec."Position 3";
                                Temp_BOMLine."Production Lead Time" := Rec."Production Lead Time";
                                Temp_BOMLine."Routing Link Code" := Rec."Routing Link Code";
                                Temp_BOMLine."Scrap %" := Rec."Scrap %";
                                Temp_BOMLine."Variant Code" := Rec."Variant Code";
                                Temp_BOMLine."Starting Date" := Rec."Starting Date";
                                Temp_BOMLine."Ending Date" := Rec."Ending Date";
                                Temp_BOMLine.Length := Rec.Length;
                                // Temp_BOMLine.Width := WIDTH;
                                Temp_BOMLine.Weight := Rec.Weight;
                                Temp_BOMLine.Depth := Rec.Depth;
                                Temp_BOMLine."Calculation Formula" := Rec."Calculation Formula";
                                Temp_BOMLine."Quantity per" := Rec."Quantity per";
                                Temp_BOMLine.Certify := Rec.Certify;
                                Temp_BOMLine.Comment := Rec.Comment;
                                Temp_BOMLine.INSERT;
                            UNTIL Rec.NEXT = 0;
                            COMMIT;
                            //------------------ 110315
                            Temp_BOMLine.RESET;
                            IF Temp_BOMLine.FIND('-') THEN
                                ;
                            Temp_BOMLine.RESET;
                            Temp_BOMLine.SETFILTER(Temp_BOMLine."No.", '<>%1', '');
                            Temp_BOMLine.SETRANGE(Temp_BOMLine.Certify, TRUE);
                            IF Temp_BOMLine.FIND('-') THEN BEGIN
                                Grcd_ProBomVer.RESET;
                                Grcd_ProBomVer.SETRANGE(Grcd_ProBomVer."Production BOM No.", Rec."Production BOM No.");
                                Grcd_ProBomVer.SETRANGE(Grcd_ProBomVer."Version Code", Gcde_NewVersion);
                                IF NOT Grcd_ProBomVer.FIND('-') THEN BEGIN
                                    Grcd_ProBomVer.INIT;
                                    Grcd_ProBomVer."Production BOM No." := Temp_BOMLine."Production BOM No.";
                                    Grcd_ProBomVer."Version Code" := Gcde_NewVersion;
                                    //   FORMAT(Gcde_SalesNo) + FORMAT(Gcdu_NoSerMage.GetNextNo(Grcd_NoSeries.Code,TODAY,TRUE));
                                    Grcd_ProBomVer."Starting Date" := WORKDATE;
                                    Grcd_ProBOMHeader.RESET;
                                    Grcd_ProBOMHeader.SETRANGE(Grcd_ProBOMHeader."No.", Rec."Production BOM No.");
                                    IF Grcd_ProBOMHeader.FINDSET THEN BEGIN
                                        Grcd_ProBomVer.Description := Grcd_ProBOMHeader.Description;
                                        Grcd_ProBomVer."Unit of Measure Code" := Grcd_ProBOMHeader."Unit of Measure Code";
                                    END;
                                    Grcd_ProBomVer."Last Date Modified" := WORKDATE;
                                    Grcd_ProBomVer.Status := Grcd_ProBomVer.Status::New;
                                    Grcd_ProBomVer.INSERT;
                                END;
                            END;
                            //++++++++++++++++++++++ 110315

                            Grcd_ProBOMLine.RESET;
                            Grcd_ProBOMLine.SETRANGE("Production BOM No.", Rec."Production BOM No.");
                            Grcd_ProBOMLine.SETRANGE("Version Code", Gcde_NewVersion);
                            Grcd_ProBOMLine.DELETEALL;
                            COMMIT;

                            Temp_BOMLine.RESET;
                            Temp_BOMLine.SETFILTER(Temp_BOMLine."No.", '<>%1', '');
                            Temp_BOMLine.SETRANGE(Temp_BOMLine.Certify, TRUE);
                            IF Temp_BOMLine.FIND('-') THEN
                                REPEAT
                                    Grcd_ProBOMLine.INIT;
                                    Gint_LineNo += 10000;
                                    Grcd_ProBOMLine."Production BOM No." := Temp_BOMLine."Production BOM No.";
                                    Grcd_ProBOMLine."Version Code" := Gcde_NewVersion;
                                    Grcd_ProBOMLine."Line No." := Gint_LineNo;
                                    Grcd_ProBOMLine.Type := Temp_BOMLine.Type;
                                    Grcd_ProBOMLine."No." := Temp_BOMLine."No.";
                                    Grcd_ProBOMLine.Description := Temp_BOMLine.Description;
                                    Grcd_ProBOMLine."Unit of Measure Code" := Temp_BOMLine."Unit of Measure Code";
                                    Grcd_ProBOMLine.Quantity := Temp_BOMLine.Quantity;
                                    Grcd_ProBOMLine.Position := Temp_BOMLine.Position;
                                    Grcd_ProBOMLine."Position 2" := Temp_BOMLine."Position 2";
                                    Grcd_ProBOMLine."Position 3" := Temp_BOMLine."Position 3";
                                    Grcd_ProBOMLine."Production Lead Time" := Temp_BOMLine."Production Lead Time";
                                    Grcd_ProBOMLine."Routing Link Code" := Temp_BOMLine."Routing Link Code";
                                    Grcd_ProBOMLine."Scrap %" := Temp_BOMLine."Scrap %";
                                    Grcd_ProBOMLine."Variant Code" := Temp_BOMLine."Variant Code";
                                    Grcd_ProBOMLine."Starting Date" := Temp_BOMLine."Starting Date";
                                    Grcd_ProBOMLine."Ending Date" := Temp_BOMLine."Ending Date";
                                    Grcd_ProBOMLine.Length := Temp_BOMLine.Length;
                                    Grcd_ProBOMLine.Width := Temp_BOMLine.Width;
                                    Grcd_ProBOMLine.Weight := Temp_BOMLine.Weight;
                                    Grcd_ProBOMLine.Depth := Temp_BOMLine.Depth;
                                    Grcd_ProBOMLine."Calculation Formula" := Temp_BOMLine."Calculation Formula";
                                    Grcd_ProBOMLine."Quantity per" := Temp_BOMLine."Quantity per";
                                    Grcd_ProBOMLine.Certify := Temp_BOMLine.Certify;
                                    Grcd_ProBOMLine.Comment := Temp_BOMLine.Comment;
                                    Grcd_ProBOMLine.INSERT;
                                UNTIL Temp_BOMLine.NEXT = 0;
                            MESSAGE('BOM Version Recreated Sucessed');
                        END;
                end;
            }
            action("Copy Sales BOM")
            {
                Caption = 'Copy Sales BOM';
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Lrcd_ProductionBOMVersion: Record "Production BOM Version";
                    Lfom_SelectBOMVersion: Page "Select Sales BOM Version";
                    Lpag_SelectBOMVersion: Page "Select Sales BOM Version";
                begin
                    Lrcd_ProductionBOMVersion.RESET;
                    Lrcd_ProductionBOMVersion.SETRANGE("Production BOM No.", Gcde_ItemNo);
                    IF Lrcd_ProductionBOMVersion.FIND('-') THEN
                        ;
                    /*
                   CLEAR(Lfom_SelectBOMVersion);
                   Lfom_SelectBOMVersion.TransforSalesNo(Gcde_SalesNo,Gcde_ItemNo,Gint_SalesLine);
                   Lfom_SelectBOMVersion.SETTABLEVIEW(Lrcd_ProductionBOMVersion);
                   Lfom_SelectBOMVersion.SETRECORD(Lrcd_ProductionBOMVersion);
                   Lfom_SelectBOMVersion.RUN;
                     */

                    CLEAR(Lpag_SelectBOMVersion);
                    Lpag_SelectBOMVersion.TransforSalesNo(Gcde_SalesNo, Gcde_ItemNo, Gint_SalesLine);
                    Lpag_SelectBOMVersion.SETTABLEVIEW(Lrcd_ProductionBOMVersion);
                    Lpag_SelectBOMVersion.SETRECORD(Lrcd_ProductionBOMVersion);
                    Lpag_SelectBOMVersion.RUN;

                end;
            }
            action("Certify All Lines")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    MODIFYALL(Certify, TRUE);
                    COMMIT;
                end;
            }
            action("UnCertify All Lines")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    MODIFYALL(Certify, FALSE);
                    COMMIT;
                end;
            }
            action("Close The Page")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin

                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        MODIFYALL(Certify, FALSE);
    end;

    var
        Grcd_ProBomVer: Record "Production BOM Version";
        Grcd_ProBOMHeader: Record "Production BOM Header";
        Grcd_ProBOMLine: Record "Production BOM Line";
        Grcd_ProBOMLine2: Record "Production BOM Line";
        Temp_BOMLine: Record "Production BOM Line" temporary;
        Grcd_NoSeries: Record "No. Series";
        Gcdu_NoSerMage: Codeunit "NoSeriesManagement";
        Gcde_NewVersion: Code[20];
        Gcde_SalesNo: Code[20];
        Gcde_ItemNo: Code[20];
        Gint_SalesLine: Integer;
        Gint_LineNo: Integer;

    procedure TestBOMNo()
    var
        BomHeaderNo: Code[20];
        TEXT001: Label 'The Production BOM item you selected are not belong to one BOM!';
    begin
        BomHeaderNo := '';
        REPEAT
            IF (BomHeaderNo = '') AND (Certify = TRUE) THEN
                BomHeaderNo := "Production BOM No."
            ELSE
                IF (BomHeaderNo <> '') AND (Certify = TRUE) THEN BEGIN
                    IF BomHeaderNo <> "Production BOM No." THEN
                        ERROR(TEXT001);
                END;
        UNTIL NEXT = 0;
    end;

    procedure TransforSalesNo(P_SalesNo: Code[20]; P_ItemNo: Code[20]; P_SalesLine: Integer)
    begin
        Gcde_SalesNo := P_SalesNo;
        Gcde_ItemNo := P_ItemNo;
        Gint_SalesLine := P_SalesLine;
    end;
}

