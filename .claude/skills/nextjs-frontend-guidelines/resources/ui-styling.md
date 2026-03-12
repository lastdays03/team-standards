# UI Components & Styling - shadcn/ui + Tailwind CSS 4

## shadcn/ui Overview

**What is shadcn/ui?**
- Beautifully designed, accessible components built on Radix UI
- Copy/paste components into your project (not a npm package dependency)
- Fully customizable with Tailwind CSS
- TypeScript-first with full type safety

**Key Concepts:**
- Components live in `src/components/ui/`
- Use `cn()` utility for class merging (clsx + tailwind-merge)
- Variants via class-variance-authority (cva)
- Follows Radix UI accessibility patterns

**Available Components in YGS:**
- button, input, textarea, card, dialog, select, checkbox, badge, alert, skeleton, image-upload

**Adding Components:**
```bash
npx shadcn@latest add button
npx shadcn@latest add card
npx shadcn@latest add dialog
npx shadcn@latest add form
```

---

## cn() Utility (IMPORTANT)

```typescript
import { cn } from '@/lib/utils';

// Conditional classes
<div className={cn(
  "flex items-center gap-2",
  isActive && "bg-primary text-white",
  isScrolled && "shadow-sm",
  className
)}>

// Status-based styling
const statusColors: Record<string, string> = {
  draft: "bg-slate-100 text-slate-600",
  active: "bg-green-100 text-green-700",
  suspended: "bg-red-100 text-red-600",
};

<Badge className={cn(statusColors[status] || "bg-gray-100")}>
  {getStatusLabel(status)}
</Badge>
```

---

## YGS Color System

```typescript
// Primary brand color (Coral/Orange)
className="bg-primary text-white"
className="hover:bg-primary-dark"
className="text-primary"

// Gradients
className="bg-gradient-to-r from-amber-500 to-orange-500"

// Status colors
className="text-red-500"     // Errors, destructive
className="bg-green-50"      // Success
className="text-gray-500"    // Muted
```

---

## Responsive Patterns

```typescript
// Grid
className="grid grid-cols-1 lg:grid-cols-4 gap-4"
className="grid grid-cols-2 lg:grid-cols-4 gap-4"

// Text
className="text-xl sm:text-2xl md:text-3xl lg:text-4xl"

// Display
className="hidden md:flex"   // Hidden on mobile
className="md:hidden"        // Mobile only

// Padding
className="px-4 sm:px-6 md:px-12"
```

---

## Form Patterns

### Pattern 1: Manual State Management (Most Common in YGS)

```typescript
'use client';

import { useState, useCallback } from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Loader2 } from 'lucide-react';

interface FormData {
  phone: string;
  name: string;
  gender: string;
  birthYear: string;
}

interface FormErrors {
  phone?: string;
  name?: string;
  gender?: string;
  birthYear?: string;
}

export function SignupForm() {
  const [formData, setFormData] = useState<FormData>({
    phone: '', name: '', gender: '', birthYear: ''
  });
  const [errors, setErrors] = useState<FormErrors>({});
  const [loading, setLoading] = useState(false);

  const validateForm = (): boolean => {
    const newErrors: FormErrors = {};

    if (!/^010-\d{4}-\d{4}$/.test(formData.phone)) {
      newErrors.phone = "올바른 전화번호 형식이 아닙니다.";
    }
    if (formData.name.length < 2) {
      newErrors.name = "이름은 2자 이상이어야 합니다.";
    }
    if (!formData.gender) {
      newErrors.gender = "성별을 선택해주세요.";
    }

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleInputChange = useCallback((field: keyof FormData, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    if (errors[field]) {
      setErrors(prev => ({ ...prev, [field]: undefined }));
    }
  }, [errors]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validateForm()) return;

    setLoading(true);
    try {
      await api.post('/signup', formData);
    } catch (err) {
      setErrors({ ...errors, phone: "회원가입에 실패했습니다." });
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div className="space-y-2">
        <Input
          value={formData.phone}
          onChange={e => handleInputChange('phone', e.target.value)}
          placeholder="전화번호"
          className={cn(errors.phone && "border-red-500")}
        />
        {errors.phone && <p className="text-sm text-red-500">{errors.phone}</p>}
      </div>
      <Button type="submit" disabled={loading} className="w-full">
        {loading ? <Loader2 className="animate-spin mr-2 h-4 w-4" /> : null}
        {loading ? "처리 중..." : "가입하기"}
      </Button>
    </form>
  );
}
```

### Pattern 2: Modal Form (Admin Edit)

```typescript
'use client';

import { useState, useEffect } from 'react';
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '@/components/ui/dialog';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { updateMemberBasic } from '@/lib/adminApi';
import type { MemberDetail } from '@/types/admin';

interface EditModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSuccess: (member: MemberDetail) => void;
  member: MemberDetail;
}

export function BasicInfoEditModal({ isOpen, onClose, onSuccess, member }: EditModalProps) {
  const [formData, setFormData] = useState({ name: '', status: '' });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    if (isOpen) {
      setFormData({ name: member.name, status: member.status });
      setError('');
    }
  }, [isOpen, member]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      // Only send changed fields
      const changes: Record<string, string> = {};
      if (formData.name !== member.name) changes.name = formData.name;
      if (formData.status !== member.status) changes.status = formData.status;

      if (Object.keys(changes).length === 0) {
        onClose();
        return;
      }

      const result = await updateMemberBasic(member.id, changes);
      onSuccess(result);
      onClose();
    } catch (err) {
      setError(err instanceof Error ? err.message : '수정에 실패했습니다.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>기본 정보 수정</DialogTitle>
        </DialogHeader>
        <form onSubmit={handleSubmit} className="space-y-4">
          <Input
            value={formData.name}
            onChange={e => setFormData(prev => ({ ...prev, name: e.target.value }))}
            placeholder="이름"
          />
          {error && <p className="text-sm text-red-500">{error}</p>}
          <DialogFooter>
            <Button type="button" variant="outline" onClick={onClose}>취소</Button>
            <Button type="submit" disabled={loading}>
              {loading ? '저장 중...' : '저장'}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
```

---

For the full styling reference, also see [styling-guide.md](styling-guide.md).
