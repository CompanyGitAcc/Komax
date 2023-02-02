pageextension 59142 "TP Production BOM List" extends "Production BOM List"
{
    layout
    {
    }

    actions
    {
        addafter("Delete Expired Components")
        {
            action("Import Production BOM")
            {
                Caption = 'Import Production BOM';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    XMLFileUserImportL: XMLport "Production BOM Line";
                begin
                    XMLFileUserImportL.Run;
                end;
            }

            // action("Import T-BOM Line")
            // {
            //     Caption = 'Import T-BOM Lines';
            //     Image = Import;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;

            //     trigger OnAction()
            //     var
            //         XMLTBOMImportL: XMLport "Import T-BOM Line";
            //     begin
            //         XMLTBOMImportL.Run;
            //     end;
            // }

            // action("Active T-BOM Version")
            // {
            //     Caption = 'Active T-BOM Version';
            //     Image = Refresh;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;

            //     trigger OnAction()
            //     var
            //         ProdBOM: Record "Production BOM Header";
            //         ProdBOMVersion: Record "Production BOM Version";
            //         ProdBOMLine: Record "Production BOM Line";
            //         ProdBOMLine2: Record "Production BOM Line";
            //     begin
            //         Window.Open('Updating #1########');

            //         ProdBOM.Reset();
            //         ProdBOM.SetFilter("No.", 'T*');
            //         if ProdBOM.FindFirst() then
            //             repeat
            //                 Window.Update(1, ProdBOM."No.");
            //                 ProdBOMVersion.SetRange("Production BOM No.", ProdBOM."No.");
            //                 if ProdBOMVersion.FindLast() then begin
            //                     ProdBOMLine.Reset();
            //                     ProdBOMLine.SetRange("Production BOM No.", ProdBOMVersion."Production BOM No.");
            //                     ProdBOMLine.SetRange("Version Code", ProdBOMVersion."Version Code");
            //                     if ProdBOMLine.FindFirst() then
            //                         repeat
            //                             ProdBOMLine2.Init();
            //                             ProdBOMLine2 := ProdBOMLine;
            //                             ProdBOMLine2."Version Code" := '';
            //                             if ProdBOMLine2.Insert() then;
            //                         until ProdBOMLine.Next() = 0;
            //                 end;
            //             until ProdBOM.Next() = 0;
            //         Window.Close();
            //     end;
            // }

            action("Certify T-BOM")
            {
                Caption = 'Certify BOM';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ProdBOM: Record "Production BOM Header";
                    ProdBOMVersion: Record "Production BOM Version";
                    ProdBOMLine: Record "Production BOM Line";
                    ProdBOMLine2: Record "Production BOM Line";
                    RunBOMCheck: Codeunit "Production BOM-Check";
                    Item: Record Item;
                begin
                    Window.Open('Updating #1########');

                    ProdBOM.Reset();
                    //ProdBOM.SetFilter("No.", 'T*');
                    ProdBOM.SetRange(Status, ProdBOM.Status::New);

                    if ProdBOM.FindFirst() then
                        repeat
                            Window.Update(1, ProdBOM."No.");
                            ProdBOM.Status := ProdBOM.Status::Certified;
                            //ProdBOM.Validate(Status, ProdBOM.Status::Certified);
                            ProdBOM.Modify();
                            if Item.Get(ProdBOM."No.") then begin
                                Item."Production BOM No." := ProdBOM."No.";
                                Item.Modify();
                            end;
                        until ProdBOM.Next() = 0;

                    ProdBOMVersion.Reset();
                    ProdBOMVersion.SetRange(Status, ProdBOMVersion.Status::New);
                    //ProdBOMVersion.SetFilter("Production BOM No.", 'T*');
                    if ProdBOMVersion.FindFirst() then
                        repeat
                            Window.Update(1, ProdBOM."No." + '_' + ProdBOM."Version Nos.");
                            //ProdBOMVersion.Validate(Status, ProdBOMVersion.Status::Certified);
                            ProdBOMVersion.Status := ProdBOMVersion.Status::Certified;
                            ProdBOMVersion.Modify();
                        until ProdBOMVersion.Next() = 0;
                    Window.Close();
                end;
            }

            action("Delete BOM")
            {
                Caption = 'Delete BOMs';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ProdBOM: Record "Production BOM Header";
                begin
                    if not Confirm('Are you sure to delete the selected BOM?') then
                        exit;
                    CurrPage.SetSelectionFilter(ProdBOM);
                    if ProdBOM.FindFirst() then
                        repeat
                            ProdBOM.Delete(true);
                        until ProdBOM.Next() = 0;
                end;
            }

            // action("Correct BOM UOM")
            // {
            //     Caption = 'Correct BOM UOM';
            //     Image = Import;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;

            //     trigger OnAction()
            //     var
            //         ProdBOMVersion: Record "Production BOM Version";
            //         ProdBOMHeader: Record "Production BOM Header";
            //     begin
            //         ProdBOMVersion.Reset();
            //         ProdBOMVersion.SetRange("Unit of Measure Code", 'MM2');
            //         if ProdBOMVersion.FindFirst() then
            //             repeat
            //                 if ProdBOMHeader.get(ProdBOMVersion."Production BOM No.") then begin
            //                     ProdBOMVersion."Unit of Measure Code" := ProdBOMHeader."Unit of Measure Code";
            //                     ProdBOMVersion.Modify();
            //                 end;
            //             until ProdBOMVersion.Next() = 0;
            //     end;
            // }

        }
    }


    var
        Window: Dialog;

}
