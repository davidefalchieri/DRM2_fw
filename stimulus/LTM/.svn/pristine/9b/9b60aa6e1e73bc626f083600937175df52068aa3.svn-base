-- Generation properties:
--   Format              : flat
--   Generic mappings    : exclude
--   Leaf-level entities : direct binding
--   Regular libraries   : use work
--   View name           : include
--   
library work;
configuration vx1392sim_config of vx1392sim is
   for struct
      for all : OSC
         use entity work.OSC(BEHAV);
      end for;
      for all : VME_MASTER
         use entity work.VME_MASTER(BEHAV);
      end for;
      for all : v1392ltm
         use entity work.v1392ltm(struct);
         for struct
            for all : I2C_INTERF
               use entity work.I2C_INTERF(RTL)
               generic map (
                  G_SIM_MODE       => TRUE  -- Fast I2C ADC read 
                );
            end for;
            
            for all : ROC32
               use entity work.ROC32(RTL)
               generic map(
                 SimCfg_NoADCEvent => FALSE
               );               
            end for;

            for all : SPI_INTERF
               use entity work.SPI_INTERF(RTL)
               generic map (
                  G_SIM_ON       => TRUE,  -- Fast SPI
                  G_LOAD_DISABLE => TRUE   -- Disable CRAM load             
                );
            end for;
 
            for all : DAC_INTERF
               use entity work.DAC_INTERF(RTL)
               generic map (
                  G_SIM_ON       => TRUE  -- Fast SPI
                );
            end for;

            for all : RESET_MOD
               use entity work.RESET_MOD(RTL)
               generic map (
                  G_SIM_ON       => TRUE  -- Fast CROM load
                );            
            end for;
            
            for all : VINTERF
               use entity work.VINTERF(RTL);
            end for;

         end for;
      end for;
      for all : vbuf
         use entity work.vbuf(struct);
         for struct
            for all : FCT16543P
               use entity work.FCT16543P(BEHAV);
            end for;
            for all : FCT1BIT543
               use entity work.FCT1BIT543(BEHAV);
            end for;
            for all : LVC16244
               use entity work.LVC16244(BEHAV);
            end for;
            for all : LVT125
               use entity work.LVT125(BEHAV);
            end for;
         end for;
      end for;
   end for;
end vx1392sim_config;
