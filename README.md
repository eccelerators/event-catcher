# EventCatcher

Its purpose is to be inherited by implementations of e.g., GPIO or Timer controllers 
utilizing this function to provide event information to SW for polling or as a prestage to 
transport events to an interrupt controller. Usually the events can be activated or deactivated at the HW block
sourcing them e.g. timer is activated or not. 
The events must be deliverered as a pulse of exactly one clock duration. 

The following picture shows the proposed HW realization as schematic attached to the HxS generateted bus.

![EventCatcherUserLogic](https://github.com/eccelerators/event-catcher/assets/124497409/791c7b7f-961e-4de3-bec9-97cc6792c2cd)

The block can be customized to handle more events by modifying the HxS description and the attached VHDL realization. 

