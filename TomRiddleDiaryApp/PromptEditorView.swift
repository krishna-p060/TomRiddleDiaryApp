//
//  PromptEditorView.swift
//  TomRiddleDiaryApp
//
//  Created by Apple on 16/06/25.
//

import SwiftUI

struct PromptEditorView: View {
    @ObservedObject var viewModel: DiaryViewModel
    @State private var editablePrompt: String = ""
    @State private var isEditing: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background similar to diary
                Color(red: 0.96, green: 0.94, blue: 0.89)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    Text("Tom Riddle's Instructions")
                        .font(.handwritten(size: 28))
                        .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.1))
                        .padding(.top, 20)
                    
                    Text("These are the instructions that guide Tom's responses:")
                        .font(.handwritten(size: 16))
                        .foregroundColor(.gray)
                    
                    // Prompt display/edit area
                    if isEditing {
                        // Edit mode
                        ScrollView {
                            TextEditorWithStyle(
                                text: $editablePrompt,
                                placeholder: "Enter Tom Riddle's instructions..."
                            )
                            .frame(minHeight: 300)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.8))
                                .shadow(radius: 2)
                        )
                    } else {
                        // Display mode
                        ScrollView {
                            Text(viewModel.getCurrentPrompt())
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundColor(.primary)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(minHeight: 300)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.8))
                                .shadow(radius: 2)
                        )
                    }
                    
                    // Action buttons
                    HStack(spacing: 15) {
                        if isEditing {
                            // Cancel button
                            Button(action: {
                                editablePrompt = viewModel.getCurrentPrompt()
                                isEditing = false
                            }) {
                                Text("Cancel")
                                    .font(.handwritten(size: 18))
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.red, lineWidth: 2)
                                    )
                            }
                            
                            Spacer()
                            
                            // Save button
                            Button(action: {
                                viewModel.updatePrompt(editablePrompt)
                                isEditing = false
                            }) {
                                Text("Save")
                                    .font(.handwritten(size: 18))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(red: 0.1, green: 0.3, blue: 0.1))
                                    )
                            }
                        } else {
                            // Edit button
                            Button(action: {
                                editablePrompt = viewModel.getCurrentPrompt()
                                isEditing = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit")
                                }
                                .font(.handwritten(size: 18))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color(red: 0.1, green: 0.3, blue: 0.1))
                                )
                            }
                            
                            Spacer()
                            
                            // Reset to default button
                            Button(action: {
                                viewModel.resetPromptToDefault()
                            }) {
                                Text("Reset")
                                    .font(.handwritten(size: 18))
                                    .foregroundColor(.orange)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.orange, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(.handwritten(size: 16))
                    .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.1))
                }
            }
        }
        .onAppear {
            editablePrompt = viewModel.getCurrentPrompt()
        }
    }
}

// Custom TextEditor with styling
struct TextEditorWithStyle: View {
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray.opacity(0.6))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
            }
            
            TextEditor(text: $text)
                .font(.system(size: 14, design: .monospaced))
                .padding(4)
                .background(Color.clear)
        }
        .padding()
    }
}

#Preview {
    PromptEditorView(viewModel: DiaryViewModel())
}
