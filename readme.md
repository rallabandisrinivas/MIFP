# MIFP

## Introduction
- A rapid finite element modeling platform for pre-processing in HyperMesh, primarily targeting Abaqus.
- **Goal**: Enhance the automation of finite element pre-processing and move away from the "manual workshop" workflow.
- **Status**: Work-in-progress 


***

## Version 

- HyperMesh 2021
- Abaqus 2021

***

## Feature List

- [ ] **Automated Modeling**
    - [ ] Create workflows
    - [ ] Auto-save
    - [x] Batch import (.stl/.inp)
    - [ ] Batch export (.stl)
- [ ] **Quick Creation**
    - [ ] Component library
    - [x] Material library
        - [x] Linear elastomers
        - [x] Elastic-plastic materials
        - [x] Hyperelastic materials
        - [x] Other materials
    - [x] Contact control
    - [x] Default outputs (Abaqus)
    - [x] Contact step outputs
    - [x] Create analysis steps (Static-Step)
- [ ] **2D Meshing**
    - [x] Batch creation of faces
    - [x] Envelope meshing
    - [ ] Cross-check
    - [x] Symmetric difference
- [ ] **3D Meshing**
    - [x] Voxelized meshing
- [ ] **Analysis**
    - [ ] Standard experiments
    - [ ] Load curves
        - [ ] Standard experiments - gait
        - [ ] Physiological conditions - gait
- [ ] **View**
    - [ ] NoFitView (non-scaled standard view)
    - [ ] User-defined view
- [ ] **Tools**
    - [ ] Material curves
    - [ ] Name editor
        - [x] Add text (prefix/suffix)
        - [x] Remove text (prefix/suffix/any position)
        - [x] Replace text
        - [ ] Standardize naming
        - [ ] Other tools
    - [ ] Model transformation (based on .inp or .odb)
        - [ ] Adjust node positions
    - [ ] Model checking
- [ ] **Abaqus Scripts**
- [ ] **Abaqus Subroutines**
    - [ ] Standard
    - [ ] Explicit
- [ ] **Job Calculation**
- [ ] **Interface**
    - [ ] Settings
    - [ ] Updates

***

## Quick Start

- **Method 1**: Run the script

    Run the `MIFP_GUI.tcl` script to access the MIFP panel.

- **Method 2**: Set a keyboard shortcut

    In "Menu Bar -> Preferences -> Keyboard Settings," map a shortcut key to the `MIFP_GUI.tcl` file.

    ![Shortcut](./Splash/Keyboard.png)

- **Main Panel**:

    ![Main Panel](./Splash/Panel.png)

***

## Changelog
- [x] **V0.2**
    - [x] **Date**: 2023.06.07
    - [x] **Updates**:
        - [x] Fixed some bugs
        - [x] UI: Added panel button annotations
        - [x] New features: Contact step outputs, batch face creation, and 2D element symmetric difference operations
- [x] **V0.1**
    - [x] **Date**: 2023.05.24
    - [x] **Updates**:
        - [x] Updated material library
        - [x] Added envelope meshing (Wrap) and voxelization features
