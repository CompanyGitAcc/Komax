xmlport 50029 "Import T-BOM Line"
{
    Caption = 'Import T-BOM Line';
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
                textelement("G_ProdBOMNo") { MinOccurs = Zero; }
                textelement("G_Version") { MinOccurs = Zero; }
                textelement("G_LineNo") { MinOccurs = Zero; }
                textelement("G_Type") { MinOccurs = Zero; }
                textelement("G_No") { MinOccurs = Zero; }
                textelement("G_Description") { MinOccurs = Zero; }
                textelement("G_UOM") { MinOccurs = Zero; }
                textelement("G_Qty") { MinOccurs = Zero; }
                textelement("G_QtyPer") { MinOccurs = Zero; }

                trigger OnBeforeInsertRecord()
                begin

                end;

                trigger OnAfterInsertRecord()
                var
                    LineNo: Integer;
                    ProdGroupMapping: Record "Product Group Mapping";
                    InventoryGroupMapping: Record "Inventory Group Mapping";
                    HasBOMHeader: Boolean;
                    BOMHeader: Record "Production BOM Header";
                    BOMVersion: Record "Production BOM Version";
                begin
                    Window.UPDATE(1, G_ProdBOMNo);
                    HasBOMHeader := false;
                    if G_No = '' then
                        exit;
                    Evaluate(LineNo, G_LineNo);
                    IF Not ProdBOMLine.GET(G_ProdBOMNo, G_Version, LineNo) THEN BEGIN
                        if (BOMHeader.Get(G_ProdBOMNo)) and (G_Version = '') then
                            HasBOMHeader := true;
                        if (BOMVersion.get(G_ProdBOMNo, G_Version)) and (G_Version <> '') then
                            HasBOMHeader := true;
                        if HasBOMHeader = true then begin
                            ProdBOMLine."Production BOM No." := G_ProdBOMNo;
                            Evaluate(ProdBOMLine.Type, G_Type);
                            ProdBOMLine."Version Code" := G_Version;
                            ProdBOMLine."Line No." := LineNo;
                            ProdBOMLine."No." := G_No;
                            ProdBOMLine."Description" := G_Description;
                            ProdBOMLine."Unit of Measure Code" := G_UOM;
                            Evaluate(ProdBOMLine.Quantity, G_Qty);
                            Evaluate(ProdBOMLine."Quantity per", G_QtyPer);
                            IF not ProdBOMLine.INSERT then
                                ProdBOMLine.Modify();
                        end;
                    END;
                    Commit();
                END;
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

    trigger OnPreXmlPort()
    var
        ProdBOMLine: Record "Production BOM Line";
    begin
        Window.OPEN('Production BOM No.#1##################');
        ProdBOMLine.Reset();
        ProdBOMLine.SetFilter("Production BOM No.", 'T*');
        if ProdBOMLine.FindFirst() then
            ProdBOMLine.DeleteAll();
    end;

    trigger OnPostXmlPort()
    begin
        Window.Close();
    end;


    var
        Window: Dialog;
        ProdBOMLine: Record "Production BOM Line";

}
