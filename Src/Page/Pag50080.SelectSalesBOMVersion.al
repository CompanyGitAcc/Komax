page 50080 "Select Sales BOM Version"
{
    PageType = List;
    SourceTable = "Production BOM Version";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Production BOM No."; Rec."Production BOM No.")
                {
                    Editable = false;
                }
                field("Version Code"; Rec."Version Code")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Editable = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = false;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Machine No."; Rec."Machine No.")
                {
                    Editable = false;
                }
                field("Select To Copy"; Rec."Select To Copy")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Create New BOM")
            {
                Caption = 'Create New BOM';
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Gint_CountSelect := 0;
                    Grcd_BOMVersion.RESET;
                    Grcd_BOMVersion.SETRANGE(Grcd_BOMVersion."Production BOM No.", Gcde_ItemNo);
                    IF Grcd_BOMVersion.FIND('-') THEN
                        REPEAT
                            IF Grcd_BOMVersion."Select To Copy" THEN
                                Gint_CountSelect += 1;
                        UNTIL Grcd_BOMVersion.NEXT = 0;
                    IF (Gint_CountSelect = 1) THEN BEGIN
                        Grcd_BOMVersion.RESET;
                        Grcd_BOMVersion.SETRANGE(Grcd_BOMVersion."Production BOM No.", Gcde_ItemNo);
                        Grcd_BOMVersion.SETRANGE(Grcd_BOMVersion."Select To Copy", TRUE);
                        IF Grcd_BOMVersion.FIND('-') THEN BEGIN
                            Gcde_VersionToCopy := Grcd_BOMVersion."Version Code";
                        END
                        ELSE
                            ERROR('The BOM Version you select is not right!');

                        Gcde_NewVersion := FORMAT(Gcde_SalesNo) + '-' + FORMAT(Gint_SalesLine + 1);
                        Grcd_ProBOMLine.RESET;
                        Grcd_ProBOMLine.SETRANGE("Production BOM No.", Gcde_ItemNo);
                        Grcd_ProBOMLine.SETRANGE("Version Code", Gcde_NewVersion);
                        IF NOT Grcd_ProBOMLine.FIND('-') THEN BEGIN
                            Grcd_ProBomVer.RESET;
                            Grcd_ProBomVer.SETRANGE(Grcd_ProBomVer."Production BOM No.", Gcde_ItemNo);
                            Grcd_ProBomVer.SETRANGE(Grcd_ProBomVer."Version Code", Gcde_NewVersion);
                            IF NOT Grcd_ProBomVer.FIND('-') THEN BEGIN
                                Grcd_ProBomVer.INIT;
                                Grcd_ProBomVer."Production BOM No." := Gcde_ItemNo;
                                Grcd_ProBomVer."Version Code" := Gcde_NewVersion;
                                Grcd_ProBomVer."Starting Date" := WORKDATE;
                                Grcd_ProBOMHeader.RESET;
                                Grcd_ProBOMHeader.SETRANGE(Grcd_ProBOMHeader."No.", Gcde_ItemNo);
                                IF Grcd_ProBOMHeader.FINDSET THEN BEGIN
                                    Grcd_ProBomVer.Description := Grcd_ProBOMHeader.Description;
                                    Grcd_ProBomVer."Unit of Measure Code" := Grcd_ProBOMHeader."Unit of Measure Code";
                                END
                                ELSE BEGIN
                                    Grcd_Item.RESET;
                                    IF Grcd_Item.GET(Gcde_ItemNo) THEN BEGIN
                                        Grcd_ProBomVer.Description := Grcd_ProBOMHeader.Description;
                                        Grcd_ProBomVer."Unit of Measure Code" := Grcd_ProBOMHeader."Unit of Measure Code";
                                    END;
                                END;
                                Grcd_ProBomVer."Last Date Modified" := WORKDATE;
                                Grcd_ProBomVer.Status := Grcd_ProBomVer.Status::New;
                                Grcd_ProBomVer.INSERT;
                            END;
                            Grcd_ProBOMLine2.RESET;
                            Grcd_ProBOMLine2.SETRANGE(Grcd_ProBOMLine2."Production BOM No.", Gcde_ItemNo);
                            Grcd_ProBOMLine2.SETRANGE(Grcd_ProBOMLine2."Version Code", Gcde_VersionToCopy);
                            IF Grcd_ProBOMLine2.FIND('-') THEN
                                REPEAT
                                    Grcd_ProBOMLine3.INIT;
                                    Grcd_ProBOMLine3."Production BOM No." := Grcd_ProBOMLine2."Production BOM No.";
                                    Grcd_ProBOMLine3."Version Code" := Gcde_NewVersion;
                                    Grcd_ProBOMLine3."Line No." := Grcd_ProBOMLine2."Line No.";
                                    Grcd_ProBOMLine3.Type := Grcd_ProBOMLine2.Type;
                                    Grcd_ProBOMLine3."No." := Grcd_ProBOMLine2."No.";
                                    Grcd_ProBOMLine3.Description := Grcd_ProBOMLine2.Description;
                                    Grcd_ProBOMLine3."Unit of Measure Code" := Grcd_ProBOMLine2."Unit of Measure Code";
                                    Grcd_ProBOMLine3.Quantity := Grcd_ProBOMLine2.Quantity;
                                    Grcd_ProBOMLine3.Position := Grcd_ProBOMLine2.Position;
                                    Grcd_ProBOMLine3."Position 2" := Grcd_ProBOMLine2."Position 2";
                                    Grcd_ProBOMLine3."Position 3" := Grcd_ProBOMLine2."Position 3";
                                    Grcd_ProBOMLine3."Production Lead Time" := Grcd_ProBOMLine2."Production Lead Time";
                                    Grcd_ProBOMLine3."Routing Link Code" := Grcd_ProBOMLine2."Routing Link Code";
                                    Grcd_ProBOMLine3."Scrap %" := Grcd_ProBOMLine2."Scrap %";
                                    Grcd_ProBOMLine3."Variant Code" := Grcd_ProBOMLine2."Variant Code";
                                    Grcd_ProBOMLine3."Starting Date" := Grcd_ProBOMLine2."Starting Date";
                                    Grcd_ProBOMLine3."Ending Date" := Grcd_ProBOMLine2."Ending Date";
                                    Grcd_ProBOMLine3.Length := Grcd_ProBOMLine2.Length;
                                    Grcd_ProBOMLine3.Width := Grcd_ProBOMLine2.Width;
                                    Grcd_ProBOMLine3.Weight := Grcd_ProBOMLine2.Weight;
                                    Grcd_ProBOMLine3.Depth := Grcd_ProBOMLine2.Depth;
                                    Grcd_ProBOMLine3."Calculation Formula" := Grcd_ProBOMLine2."Calculation Formula";
                                    Grcd_ProBOMLine3."Quantity per" := Grcd_ProBOMLine2."Quantity per";
                                    Grcd_ProBOMLine3."Description 2" := Grcd_ProBOMLine2."Description 2";
                                    Grcd_ProBOMLine3.INSERT;
                                UNTIL Grcd_ProBOMLine2.NEXT = 0;
                            MESSAGE('Create BOM Version Sucessed');
                        END
                        ELSE BEGIN
                            IF CONFIRM(Text0002) THEN BEGIN
                                Gcde_NewVersion := FORMAT(Gcde_SalesNo) + '-' + FORMAT(Gint_SalesLine + 1);
                                // Grcd_ProBOMLine.RESET;
                                // Grcd_ProBOMLine.SETRANGE("Production BOM No.",Gcde_ItemNo);
                                // Grcd_ProBOMLine.SETRANGE("Version Code",Gcde_NewVersion);
                                // IF NOT Grcd_ProBOMLine.FIND('-') THEN BEGIN
                                Grcd_ProBomVer.RESET;
                                Grcd_ProBomVer.SETRANGE(Grcd_ProBomVer."Production BOM No.", Gcde_ItemNo);
                                Grcd_ProBomVer.SETRANGE(Grcd_ProBomVer."Version Code", Gcde_NewVersion);
                                IF NOT Grcd_ProBomVer.FIND('-') THEN BEGIN
                                    Grcd_ProBomVer.INIT;
                                    Grcd_ProBomVer."Production BOM No." := Gcde_ItemNo;
                                    Grcd_ProBomVer."Version Code" := Gcde_NewVersion;
                                    Grcd_ProBomVer."Starting Date" := WORKDATE;
                                    Grcd_ProBOMHeader.RESET;
                                    Grcd_ProBOMHeader.SETRANGE(Grcd_ProBOMHeader."No.", Gcde_ItemNo);
                                    IF Grcd_ProBOMHeader.FINDSET THEN BEGIN
                                        Grcd_ProBomVer.Description := Grcd_ProBOMHeader.Description;
                                        Grcd_ProBomVer."Unit of Measure Code" := Grcd_ProBOMHeader."Unit of Measure Code";
                                    END
                                    ELSE BEGIN
                                        Grcd_Item.RESET;
                                        IF Grcd_Item.GET(Gcde_ItemNo) THEN BEGIN
                                            Grcd_ProBomVer.Description := Grcd_ProBOMHeader.Description;
                                            Grcd_ProBomVer."Unit of Measure Code" := Grcd_ProBOMHeader."Unit of Measure Code";
                                        END;
                                    END;
                                    Grcd_ProBomVer."Last Date Modified" := WORKDATE;
                                    Grcd_ProBomVer.Status := Grcd_ProBomVer.Status::New;
                                    Grcd_ProBomVer.INSERT;
                                END;

                                Grcd_ProBOMLine3.RESET;
                                Grcd_ProBOMLine3.SETRANGE("Production BOM No.", Gcde_ItemNo);
                                Grcd_ProBOMLine3.SETRANGE("Version Code", Gcde_NewVersion);
                                Grcd_ProBOMLine3.DELETEALL;

                                Grcd_ProBOMLine2.RESET;
                                Grcd_ProBOMLine2.SETRANGE(Grcd_ProBOMLine2."Production BOM No.", Gcde_ItemNo);
                                Grcd_ProBOMLine2.SETRANGE(Grcd_ProBOMLine2."Version Code", Gcde_VersionToCopy);
                                IF Grcd_ProBOMLine2.FIND('-') THEN
                                    REPEAT
                                        Grcd_ProBOMLine3.INIT;
                                        Grcd_ProBOMLine3."Production BOM No." := Grcd_ProBOMLine2."Production BOM No.";
                                        Grcd_ProBOMLine3."Version Code" := Gcde_NewVersion;
                                        Grcd_ProBOMLine3."Line No." := Grcd_ProBOMLine2."Line No.";
                                        Grcd_ProBOMLine3.Type := Grcd_ProBOMLine2.Type;
                                        Grcd_ProBOMLine3."No." := Grcd_ProBOMLine2."No.";
                                        Grcd_ProBOMLine3.Description := Grcd_ProBOMLine2.Description;
                                        Grcd_ProBOMLine3."Unit of Measure Code" := Grcd_ProBOMLine2."Unit of Measure Code";
                                        Grcd_ProBOMLine3.Quantity := Grcd_ProBOMLine2.Quantity;
                                        Grcd_ProBOMLine3.Position := Grcd_ProBOMLine2.Position;
                                        Grcd_ProBOMLine3."Position 2" := Grcd_ProBOMLine2."Position 2";
                                        Grcd_ProBOMLine3."Position 3" := Grcd_ProBOMLine2."Position 3";
                                        Grcd_ProBOMLine3."Production Lead Time" := Grcd_ProBOMLine2."Production Lead Time";
                                        Grcd_ProBOMLine3."Routing Link Code" := Grcd_ProBOMLine2."Routing Link Code";
                                        Grcd_ProBOMLine3."Scrap %" := Grcd_ProBOMLine2."Scrap %";
                                        Grcd_ProBOMLine3."Variant Code" := Grcd_ProBOMLine2."Variant Code";
                                        Grcd_ProBOMLine3."Starting Date" := Grcd_ProBOMLine2."Starting Date";
                                        Grcd_ProBOMLine3."Ending Date" := Grcd_ProBOMLine2."Ending Date";
                                        Grcd_ProBOMLine3.Length := Grcd_ProBOMLine2.Length;
                                        Grcd_ProBOMLine3.Width := Grcd_ProBOMLine2.Width;
                                        Grcd_ProBOMLine3.Weight := Grcd_ProBOMLine2.Weight;
                                        Grcd_ProBOMLine3.Depth := Grcd_ProBOMLine2.Depth;
                                        Grcd_ProBOMLine3."Calculation Formula" := Grcd_ProBOMLine2."Calculation Formula";
                                        Grcd_ProBOMLine3."Quantity per" := Grcd_ProBOMLine2."Quantity per";
                                        Grcd_ProBOMLine3."Description 2" := Grcd_ProBOMLine2."Description 2";
                                        Grcd_ProBOMLine3.INSERT;
                                    UNTIL Grcd_ProBOMLine2.NEXT = 0;
                                MESSAGE('BOM Version Recreated Sucessed');
                            END;
                        END;
                    END
                    ELSE
                        ERROR(Text0001);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.MODIFYALL("Select To Copy", FALSE);
    end;

    var
        Text0001: Label 'You must select only one BOM Version to Copy!';
        Text0002: Label 'The Version you want to create has been exist,Do you want to Record it? Yes / No';
        Grcd_ProBomVer: Record "Production BOM Version";
        Grcd_ProBOMHeader: Record "Production BOM Header";
        Grcd_ProBOMLine: Record "Production BOM Line";
        Grcd_ProBOMLine2: Record "Production BOM Line";
        Grcd_ProBOMLine3: Record "Production BOM Line";
        Grcd_Item: Record "Item";
        Temp_BOMLine: Record "Production BOM Line" temporary;
        Grcd_NoSeries: Record "No. Series";
        Gcdu_NoSerMage: Codeunit "NoSeriesManagement";
        Gcde_NewVersion: Code[20];
        Grcd_BOMVersion: Record "Production BOM Version";
        Gcde_VersionToCopy: Code[20];
        Gcde_SalesNo: Code[20];
        Gcde_ItemNo: Code[20];
        Gint_SalesLine: Integer;
        Gint_CountSelect: Integer;

    procedure TransforSalesNo(P_SalesNo: Code[20]; P_ItemNo: Code[20]; P_SalesLine: Integer)
    begin
        Gcde_SalesNo := P_SalesNo;
        Gcde_ItemNo := P_ItemNo;
        Gint_SalesLine := P_SalesLine;
    end;
}

