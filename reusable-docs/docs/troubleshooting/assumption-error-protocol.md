# 🔧 Error Prevention & Assumption Validation

## **Quick Reference for Assumption Errors**

When GitHub Copilot makes an assumption error, follow this protocol:

### **Standard Response Format:**
```markdown
🚨 **ASSUMPTION ERROR ACKNOWLEDGED**

**You're absolutely right!** I made an incorrect assumption about: {specific_assumption}

🔧 **Immediate Correction**:
- {specific_fix_for_current_issue}
- {verification_of_actual_state}  
- {corrected_implementation_approach}

📚 **Documentation Update Offer**:
- [ ] Add verification step to prevent this assumption error
- [ ] Update copilot instructions with new validation requirement
- [ ] Create verification script/guide for future use
- [ ] Add this to troubleshooting documentation

🎯 **Prevention Strategy**:
- ✅ Add assumption validation step: {specific_verification_method}
- ✅ Update workflow to include: {specific_verification_step}
- ✅ Create documentation: {specific_guide_or_script}

**Would you like me to proceed with these documentation updates?**
```

---

## **Common Assumption Errors & Prevention**

### **Database Assumptions**
- ❌ **Error**: Assuming tables exist without verification
- ✅ **Prevention**: Run `supabase/check-current-database-state.sql` first
- 📚 **Guide**: `docs/authentication/supabase-database-verification-guide.md`

### **Code Structure Assumptions**  
- ❌ **Error**: Assuming interfaces match implementation
- ✅ **Prevention**: Use `read_file` before making changes
- 📚 **Guide**: Always verify current code state

### **Configuration Assumptions**
- ❌ **Error**: Assuming scripts/commands exist
- ✅ **Prevention**: Check `package.json` and config files first
- 📚 **Guide**: Verify environment before proceeding

---

## **Documentation Update Process**

When assumption errors occur:
1. ✅ **Acknowledge error immediately**
2. ✅ **Fix current issue**
3. ✅ **Offer documentation updates**
4. ✅ **Create prevention strategies**
5. ✅ **Update relevant guides**

---

**📚 Complete Guide**: `docs/development/assumption-validation-guide.md`
